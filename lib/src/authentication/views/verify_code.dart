import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:webrtc_chat/core/components/indicators/circular_progress.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/authentication/controller/authentication_controller.dart';

class VerifyOtp extends GetView<AuthenticationController> {
  const VerifyOtp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final phone = Get.arguments['phone'] ?? '';
    final verificationID = Get.arguments['verificationID'] ?? '';
    final countryCode = phone.split(' ')[0];
    final number = phone.split(' ')[1];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: Text(
            'OTP Verfication',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(letterSpacing: 1),
          ),
        ),
        body: Obx(
          () => LoadingOverlay(
            isLoading: controller.loading.value,
            progressIndicator: circularProgress(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView(
                children: [
                  SizedBox(height: 40.h),
                  Text('We have sent a verification code to',
                      style: GoogleFonts.lexend(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLighter)),
                  SizedBox(height: 8.w),
                  Text('$countryCode-XXXXXX${number.substring(6)}',
                      style: GoogleFonts.lexend(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black)),
                  SizedBox(width: 5.w),
                  // OTP FIELD
                  SizedBox(height: 16.h),

                  Pinput(
                    length: 6,
                    autofocus: true,
                    onCompleted: (otp) {
                      controller.verifyCode(otp, verificationID);
                    },
                    defaultPinTheme: PinTheme(
                      width: 56.h,
                      height: 56.w,
                      textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600),
                      decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: AppColors.border)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Didn’t receive code? ',
                      style: GoogleFonts.lexend(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Resend Again.',
                          style: GoogleFonts.lexend(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Privacy Policy tap
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
