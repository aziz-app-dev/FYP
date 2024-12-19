import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.radius,
    this.child,
  });

  final void Function()? onTap;
  final double? btnWidth;
  final double? btnHeight;
  final double? radius;
  final Color? btnColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth ?? 77.w,
        height: btnHeight ?? 28.h,
        decoration: BoxDecoration(
          color: btnColor ?? kPrimary,
          borderRadius: BorderRadius.circular(radius ?? 12.r),
        ),
        child: child,
      ),
    );
  }
}
