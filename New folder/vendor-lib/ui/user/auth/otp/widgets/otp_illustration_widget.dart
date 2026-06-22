import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/config.dart';

Widget buildOtpIllustration() {
  return Center(
    child: Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withValues(alpha: 0.2),
            AppColors.secondaryLight.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.pin_outlined,
              color: AppColors.secondary,
              size: 48.spMin,
            ),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_outline,
                color: AppColors.textOnPrimary,
                size: 18.spMin,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
