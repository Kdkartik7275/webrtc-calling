import 'package:get/get.dart';
import 'package:webrtc_chat/src/bottom_navbar/binding/bottom_navbar_binding.dart';
import 'package:webrtc_chat/src/splash/binding/splash_binding.dart';
import 'package:webrtc_chat/src/splash/view/splash_view.dart';
import 'package:webrtc_chat/src/authentication/binding/authentication_binding.dart';
import 'package:webrtc_chat/src/authentication/views/login_view.dart';
import 'package:webrtc_chat/src/authentication/views/user_initialization.dart';
import 'package:webrtc_chat/src/authentication/views/verify_code.dart';
import 'package:webrtc_chat/src/bottom_navbar/view/bottom_navbar_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      binding: AuthenticationBinding(),
      page: () => const LoginView(),
    ),
    GetPage(
      name: _Paths.VERIFYCODE,
      page: () => const VerifyOtp(),
    ),
    GetPage(
      name: _Paths.USERINIT,
      page: () => const UserInitialization(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVBAR,
      binding: BottomNavbarBinding(),
      page: () => const BottomNavbarView(),
    ),
    GetPage(
      binding: SplashBinding(),
      name: _Paths.SPLASH,
      page: () => const SplashView(),
    ),
  ];
}
