import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? hintText;
  final Color borderColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final double cursorHeight;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.keyboardType,
    this.onEditingComplete,
    this.obscureText,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.borderColor = kGray,
    this.borderRadius = 9.0,
    this.textStyle,
    this.hintStyle,
    this.cursorHeight = 20.0,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.h),
      padding: EdgeInsets.only(left: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 0.4),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        obscureText: obscureText ?? false,
        cursorHeight: 25.spMin,
        style: textStyle ?? appStyle(18.spMin, kDark, FontWeight.normal),
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: hintStyle ?? appStyle(14.spMin, kDark, FontWeight.normal),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

TextStyle appStyle(double fontSize, Color color, FontWeight fontWeight) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}
