// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/components/fields/text_field.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TRoundedContainer(
        height: 50.h,
        showBorder: true,
        radius: 10.r,
        borderColor: AppColors.border,
        alignment: Alignment.center,
        child: TTextField(
            controller: controller,
            hintText: 'Enter Phone Number',
            onChanged: onChanged),
      ),
    );
  }
}
