import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/authentication/controller/authentication_controller.dart';
import 'package:webrtc_chat/src/authentication/widgets/phone_auth.dart';
import 'package:webrtc_chat/src/authentication/widgets/terms_conditions.dart';

class LoginView extends GetView<AuthenticationController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              const LoginHeaderr(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    TRoundedContainer(
                      height: 30.h,
                      width: 300.w,
                      radius: 12.r,
                      backgroundColor: AppColors.filled,
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linearToEaseOut,
                            left: controller.emailLogin.value ? 0 : 150.w,
                            child: TRoundedContainer(
                              height: 27.h,
                              width: 150.w,
                              radius: 12.r,
                              backgroundColor: AppColors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => controller.emailLogin.value = true,
                                child: SizedBox(
                                  height: 27.h,
                                  width: 150.w,
                                  child: Center(
                                    child: Text(
                                      'Email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    controller.emailLogin.value = false,
                                child: SizedBox(
                                  height: 27.h,
                                  width: 150.w,
                                  child: Center(
                                    child: Text(
                                      'Phone Number',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    controller.emailLogin.value
                        ? const SizedBox()
                        : const PhoneAuth()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: const TermsAndConditions(),
      ),
    );
  }
}

class LoginHeaderr extends StatelessWidget {
  const LoginHeaderr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      height: 382.h,
      width: 375.w,
      customRadiusRequired: true,
      customRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32.r),
        bottomRight: Radius.circular(32.r),
      ),
      backgroundColor: AppColors.primary,
      child: Container(
        height: 291.h,
        width: 327.w,
        margin: EdgeInsets.fromLTRB(20.w, 68.h, 20.w, 20.h),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: Container(
                height: 270.r,
                width: 270.r,
                color: const Color(0xffFAEED1),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0.w,
                      bottom: -20.h,
                      child: Image.asset(
                        'assets/images/call.png',
                        height: 200.h,
                        width: 200.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Login to your Account',
              style: GoogleFonts.lexend(
                fontSize: 19.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
