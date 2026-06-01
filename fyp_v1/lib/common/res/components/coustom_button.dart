import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.radius,
    required this.text,
  });

  final void Function()? onTap;
  final double? btnWidth;
  final double? btnHeight;
  final double? radius;
  final Color? btnColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth ?? double.infinity,
        height: btnHeight ?? 40.h,
        decoration: BoxDecoration(
          color: btnColor ?? kPrimary,
          borderRadius: BorderRadius.circular(radius ?? 12.r),
        ),
        child: Center(
            child: ReuseableText(
          text: text,
          fontSize: 14.spMin,
          fontWeight: FontWeight.w400,
          textColor: kWhite,
        )),
      ),
    );
  }
}
