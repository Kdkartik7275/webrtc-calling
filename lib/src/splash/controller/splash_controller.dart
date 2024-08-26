import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/utils/constants/app_pages.dart';

class SplashController extends GetxController {
  late Rx<User?> _user;

  User? get user => _user.value;

  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _user = Rx<User?>(_auth.currentUser);
        _user.bindStream(_auth.authStateChanges());
        ever(_user, _setInitialView);
      },
    );
  }

  _setInitialView(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.BOTTOMNAVBAR);
    }
  }
}
