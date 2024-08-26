import 'package:get/get.dart';
import 'package:webrtc_chat/src/bottom_navbar/controller/bottom_navbar_controller.dart';

class BottomNavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(() => BottomNavBarController());
  }
}
