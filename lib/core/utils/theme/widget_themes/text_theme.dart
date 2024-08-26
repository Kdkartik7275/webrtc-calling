import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';

/// Custom Class for Light & Dark Text Themes
class TTextTheme {
  TTextTheme._(); // To avoid creating instances

  /// Customizable Light Text Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.capriola().copyWith(
        fontSize: 32.0.sp, fontWeight: FontWeight.w900, color: AppColors.text),
    headlineMedium: GoogleFonts.capriola().copyWith(
        fontSize: 30.sp, fontWeight: FontWeight.w700, color: AppColors.text),
    headlineSmall: GoogleFonts.capriola().copyWith(
        fontSize: 24.0.sp, fontWeight: FontWeight.w500, color: AppColors.text),
    titleLarge: GoogleFonts.capriola().copyWith(
        fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: AppColors.text),
    titleMedium: GoogleFonts.capriola().copyWith(
        fontSize: 19.0.sp, fontWeight: FontWeight.w700, color: AppColors.text),
    titleSmall: GoogleFonts.lexend().copyWith(
        fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: AppColors.text),
  );
}
