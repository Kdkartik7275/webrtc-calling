import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:webrtc_chat/core/components/containers/circular_container.dart';
import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/components/fields/text_field.dart';
import 'package:webrtc_chat/core/components/indicators/circular_progress.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/profile/controller/profile_controller.dart';

class UserInitialization extends StatefulWidget {
  const UserInitialization({super.key});

  @override
  State<UserInitialization> createState() => _UserInitializationState();
}

class _UserInitializationState extends State<UserInitialization> {
  final controller = Get.find<ProfileController>();

  final name = TextEditingController(text: '');
  final bio = TextEditingController(text: '');

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.loading.value,
          progressIndicator: circularProgress(context),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Just a step away !',
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.topCenter,
                        child: TCircularContainer(
                          height: 100.h,
                          width: 100.w,
                          backgroundColor: AppColors.filled,
                          child: Stack(
                            children: [
                              if (controller.userProfile.value != null)
                                CircleAvatar(
                                  radius: 50.r,
                                  backgroundColor: AppColors.filled,
                                  backgroundImage: FileImage(
                                      File(controller.userProfile.value!.path)),
                                ),
                              Positioned(
                                bottom: 6,
                                right: 0,
                                child: IconButton(
                                    icon: const Icon(
                                        Icons.photo_camera_outlined,
                                        color: AppColors.black,
                                        size: 30),
                                    onPressed: () {
                                      controller.pickProfileImage();
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      TRoundedContainer(
                        showBorder: true,
                        radius: 10.r,
                        borderColor: AppColors.border,
                        alignment: Alignment.center,
                        child: TTextField(
                            controller: name, hintText: 'Enter Full Name'),
                      ),
                      SizedBox(height: 12.h),
                      TRoundedContainer(
                        showBorder: true,
                        radius: 10.r,
                        borderColor: AppColors.border,
                        alignment: Alignment.center,
                        child:
                            TTextField(controller: bio, hintText: 'Enter Bio'),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => controller.userProfileInit(
                              FirebaseAuth.instance.currentUser!.uid,
                              name.text,
                              bio.text),
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            height: controller.loading.value ? 50.h : 44.sp,
                            width: controller.loading.value ? 55.w : 327.w,
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(
                                    controller.loading.value ? 100.r : 10.r)),
                            alignment: Alignment.center,
                            child: controller.loading.value
                                ? const CircularProgressIndicator(
                                    color: AppColors.white)
                                : Text(
                                    'Let’s Start',
                                    style: GoogleFonts.lexend(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
