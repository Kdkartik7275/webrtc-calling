import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/authentication/controller/authentication_controller.dart';
import 'package:webrtc_chat/src/authentication/widgets/phone_field.dart';

class PhoneAuth extends GetView<AuthenticationController> {
  const PhoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    onSelect: (country) {
                      controller.selectedCountry.value = country;
                    },
                  );
                },
                child: TRoundedContainer(
                  height: 50.h,
                  width: 55.w,
                  showBorder: true,
                  radius: 10.r,
                  borderColor: AppColors.border,
                  alignment: Alignment.center,
                  child: Text(
                    "+${controller.selectedCountry.value.phoneCode}",
                    style: GoogleFonts.lexend(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              PhoneTextField(
                onChanged: (value) {
                  controller.phone.value = value;
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                controller.sendCodeToPhone();
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                height: controller.loading.value ? 50.h : 44.sp,
                width: controller.loading.value ? 55.w : 327.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    controller.loading.value ? 100.r : 10.r,
                  ),
                ),
                alignment: Alignment.center,
                child: controller.loading.value
                    ? const CircularProgressIndicator(
                        color: AppColors.white,
                      )
                    : Text(
                        'Get OTP',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
