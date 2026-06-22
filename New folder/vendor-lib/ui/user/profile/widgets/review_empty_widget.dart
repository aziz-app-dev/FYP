import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/config.dart';

Widget reviewEmptyState(ThemeColors colors) {
  return Align(
    alignment: Alignment(0.0, -0.3),
    child: Padding(
      padding: AppSizes.paddingAllLg,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/Rating.json',
              width: 150.spMin,
              height: 150.spMin,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150.spMin,
                height: 150.spMin,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rate_review_outlined,
                  size: 70.spMin,
                  color: colors.primary,
                ),
              ),
            ),
            SizedBox(height: 16.spMin),
            Text(
              'No Reviews Yet',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.spMin),
            Text(
              'Your reviews will appear here\nafter you rate foods, restaurants, or drivers',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
