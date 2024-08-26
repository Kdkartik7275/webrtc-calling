// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:webrtc_chat/core/utils/constants/colors.dart';

class TTextField extends StatelessWidget {
  const TTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  final String hintText;

  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.lexend(
          fontSize: 13.sp, fontWeight: FontWeight.w400, color: AppColors.black),
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          hintStyle: GoogleFonts.lexend(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textLighter),
          border: InputBorder.none),
    );
  }
}
