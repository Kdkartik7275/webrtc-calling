import 'package:get/get.dart';
import 'package:webrtc_chat/core/components/models/user.dart';
import 'package:webrtc_chat/services/calling/webrtc_service.dart';
import 'package:webrtc_chat/services/user/user_services.dart';
import 'package:webrtc_chat/src/call/controller/call_controller.dart';
import 'package:webrtc_chat/src/call/view/video_calll.dart';

class ChatsController extends GetxController {
  var loading = false.obs;

  var users = Rx<List<UserModel>>([]);

  final _services = UserServices();

  final CallService _callService = Get.put(CallService());
  final CallController _callController = Get.put(CallController());

  @override
  void onInit() {
    super.onInit();
    getAllUssers();
  }

  void getAllUssers() async {
    try {
      loading.value = true;
      final data = await _services.getAllUsers();

      users.value = data;
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void makeVideoCall(String callerId, String receiverId) async {
    loading.value = true;
    try {
      await _callService.openUserMedia(_callController.localRenderer);
      await _callService.makeCall(callerId, receiverId,
          _callController.localRenderer, _callController.remoteRenderer);
      loading.value = false;
      Get.to(() => VideoCallScreen());
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', 'Failed to start call: $e');
    }
  }
}
