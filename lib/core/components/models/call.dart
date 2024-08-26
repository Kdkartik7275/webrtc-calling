import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Call {
  final String id;
  final String callerId;
  final String receiverId;
  final String status;
  final RTCSessionDescription? offer;
  final RTCSessionDescription? answer;

  Call({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.status,
    this.offer,
    this.answer,
  });

  factory Call.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Call(
      id: doc.id,
      callerId: data['callerId'],
      receiverId: data['receiverId'],
      status: data['status'],
      offer: data['offer'] != null
          ? RTCSessionDescription(data['offer']['sdp'], data['offer']['type'])
          : null,
      answer: data['answer'] != null
          ? RTCSessionDescription(data['answer']['sdp'], data['answer']['type'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'status': status,
      'offer': offer?.toMap(),
      'answer': answer?.toMap(),
      'id': id
    };
  }
}
