import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: TRoundedContainer(
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
            child: ClipOval(
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
          ),
        ),
      ),
    );
  }
}
