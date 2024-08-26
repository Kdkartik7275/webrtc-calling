import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/components/dialogs/incoming_call.dart';
import 'package:webrtc_chat/core/components/models/call.dart';
import 'package:webrtc_chat/services/calling/webrtc_service.dart';
import 'package:webrtc_chat/services/user/user_services.dart';
import 'package:webrtc_chat/src/call/view/video_calll.dart';

class CallController extends GetxController {
  final CallService _callService = CallService();

  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  RxBool isInCall = false.obs;

  Rx<Call?> currentCall = Rx<Call?>(null);

  final _services = UserServices();

  @override
  void onInit() {
    super.onInit();
    localRenderer.initialize();
    remoteRenderer.initialize();

    // Start listening for incoming calls
    _listenForIncomingCalls();
  }

  Future<void> makeCall(String callerId, String receiverId) async {
    await _callService.openUserMedia(localRenderer);
    final call = await _callService.makeCall(
        callerId, receiverId, localRenderer, remoteRenderer);
    isInCall.value = true;
    currentCall.value = call;
    Get.to(() => const VideoCallScreen());
  }

  Future<void> receiveCall(String callerId, String receiverId) async {
    await _callService.openUserMedia(localRenderer);
    final call = await _callService.receiveCall(
        callerId, receiverId, localRenderer, remoteRenderer);
    isInCall.value = true;
    currentCall.value = call;
    Get.to(() => const VideoCallScreen());
  }

  Future<void> hangUp(String callerId, String receiverId,
      {bool isdeclined = false}) async {
    await _callService.hangUp(callerId, receiverId, isdeclined: isdeclined);
    isInCall.value = false;
    currentCall.value = null;
    Get.back();
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void _listenForIncomingCalls() {
    String receiverId = FirebaseAuth.instance.currentUser!.uid;

    _callService
        .listenForIncomingCalls(receiverId)
        .listen((callSnapshot) async {
      if (callSnapshot != null) {
        String callerId = callSnapshot['callerId'];
        String receiverId = callSnapshot['receiverId'];

        final caller = await _services.fetchUserByID(callerId);

        // Show a screen with options to accept or decline the call
        Get.dialog(IncomingCallDialog(caller: caller, receiverId: receiverId));
      }
    });
  }

  Stream<Call?> listenForCallUpdates(String callId) {
    return _callService.listenForCallUpdates(callId);
  }

  void switchCamera() {
    _callService.switchCamera();
  }
}
