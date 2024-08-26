import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_chat/core/components/models/call.dart';

typedef void StreamStateCallback(MediaStream stream);

class CallService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  StreamStateCallback? onAddRemoteStream;
  Future<Call> makeCall(String callerId, String receiverId,
      RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    _peerConnection = await createPeerConnection(configuration);
    _registerPeerConnectionListeners();

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    var roomRef = _db.collection('calls').doc('$callerId-$receiverId');

    var callerCandidatesCollection = roomRef.collection('callerCandidates');
    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      callerCandidatesCollection.add(candidate.toMap());
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    var call = Call(
      id: '$callerId-$receiverId',
      callerId: callerId,
      receiverId: receiverId,
      status: 'ringing',
      offer: offer,
    );

    await roomRef.set(call.toMap());

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        remoteRenderer.srcObject = _remoteStream;
      }
    };

    roomRef.snapshots().listen((snapshot) async {
      var callData = Call.fromDocumentSnapshot(snapshot);
      if (_peerConnection?.getRemoteDescription() != null &&
          callData.answer != null) {
        await _peerConnection?.setRemoteDescription(callData.answer!);
      }
    });

    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          _peerConnection!.addCandidate(RTCIceCandidate(
              data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
        }
      }
    });

    return call;
  }

  Future<Call?> receiveCall(String callerId, String receiverId,
      RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    var roomRef = _db.collection('calls').doc('$callerId-$receiverId');
    var roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      var call = Call.fromDocumentSnapshot(roomSnapshot);

      _peerConnection = await createPeerConnection(configuration);
      _registerPeerConnectionListeners();

      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      _peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate != null) {
          calleeCandidatesCollection.add(candidate.toMap());
        }
      };

      _peerConnection?.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          _remoteStream = event.streams[0];
          remoteRenderer.srcObject = _remoteStream;
        }
      };

      await _peerConnection?.setRemoteDescription(call.offer!);

      var answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      await roomRef.update({
        'answer': {'type': answer.type, 'sdp': answer.sdp},
        'status': 'inCall'
      });

      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var document in snapshot.docChanges) {
          var data = document.doc.data() as Map<String, dynamic>;
          _peerConnection!.addCandidate(RTCIceCandidate(
              data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
        }
      });

      return call;
    }
    return null;
  }

  Future<void> openUserMedia(RTCVideoRenderer localRenderer) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});
    localRenderer.srcObject = stream;
    _localStream = stream;
  }

  Future<void> hangUp(String callerId, String receiverId,
      {bool isdeclined = false}) async {
    // Close peer connection and dispose of media streams
    _peerConnection?.close();
    _localStream?.dispose();
    _remoteStream?.dispose();

    // Find the room reference by searching for the document with matching callerId and receiverId
    var roomQuery = _db
        .collection('calls')
        .where('callerId', isEqualTo: callerId)
        .where('receiverId', isEqualTo: receiverId)
        .limit(1);

    var roomSnapshot = await roomQuery.get();
    if (roomSnapshot.docs.isNotEmpty) {
      var roomRef = roomSnapshot.docs.first.reference;

      // Delete ICE candidates
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      var callerCandidates = await roomRef.collection('callerCandidates').get();
      for (var doc in calleeCandidates.docs) {
        doc.reference.delete();
      }
      for (var doc in callerCandidates.docs) {
        doc.reference.delete();
      }

      await roomRef.update({
        'status': isdeclined ? 'declined' : 'disconnected',
      });

      await roomRef.delete();
    }

    // Optionally, notify the other party that the call has been disconnected
    var otherPartyId = callerId == FirebaseAuth.instance.currentUser?.uid
        ? receiverId
        : callerId;
    var otherPartyRoomQuery = _db
        .collection('calls')
        .where('callerId', isEqualTo: otherPartyId)
        .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1);

    var otherPartyRoomSnapshot = await otherPartyRoomQuery.get();
    if (otherPartyRoomSnapshot.docs.isNotEmpty) {
      var otherPartyRoomRef = otherPartyRoomSnapshot.docs.first.reference;
      await otherPartyRoomRef.update({
        'status': isdeclined ? 'declined' : 'disconnected' 'disconnected',
      });
    }
  }

  Stream<Call?> listenForCallUpdates(String callId) {
    return _db.collection('calls').doc(callId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Call.fromDocumentSnapshot(snapshot);
      }
      return null;
    });
  }

  void _registerPeerConnectionListeners() {
    _peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    _peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    _peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      print('ICE connection state change: $state');
    };

    _peerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      _remoteStream = stream;
      // Ensure to update the remoteRenderer here if needed
    };
  }

  void switchCamera() async {
    if (_localStream != null) {
      final videoTrack = _localStream!
          .getVideoTracks()
          .firstWhere((track) => track.kind == 'video');
      await Helper.switchCamera(videoTrack);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>?> listenForIncomingCalls(
      String receiverId) {
    return _db
        .collection('calls')
        .where('receiverId', isEqualTo: receiverId)
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      } else {
        return null;
      }
    }).where((doc) => doc != null);
  }
}
