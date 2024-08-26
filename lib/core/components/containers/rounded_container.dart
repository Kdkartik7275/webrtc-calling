// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:webrtc_chat/core/utils/constants/colors.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.height,
    this.width,
    this.radius = 20,
    this.child,
    this.margin,
    this.padding,
    this.backgroundColor = AppColors.white,
    this.showBorder = false,
    this.borderColor = AppColors.border,
    this.boxShadow,
    this.alignment,
    this.borderWidth = 1.0,
    this.customRadius,
    this.customRadiusRequired = false,
  });

  final double? height;
  final double? width;
  final double radius;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showBorder;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;
  final Alignment? alignment;
  final double borderWidth;
  final BorderRadius? customRadius;
  final bool customRadiusRequired;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: customRadiusRequired
            ? customRadius
            : BorderRadius.circular(radius.r),
        color: backgroundColor,
        border: showBorder
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
