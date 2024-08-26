import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/utils/constants/app_pages.dart';
import 'package:webrtc_chat/core/utils/theme/theme.dart';
import 'package:webrtc_chat/firebase_options.dart';
import 'package:webrtc_chat/src/profile/controller/profile_controller.dart';
import 'package:webrtc_chat/src/splash/controller/splash_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    Get.put(ProfileController());
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      child: GetMaterialApp(
        title: 'WebRTC',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
