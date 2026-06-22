import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/config.dart';

Widget orderEmptyWidget(ThemeColors colors, {bool useViewportHeight = false}) {
  final content = Padding(
    padding: AppSizes.paddingAllLg,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/lottie/Order History.json',
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
              Icons.receipt_long_outlined,
              size: 70.spMin,
              color: colors.primary,
            ),
          ),
        ),
        SizedBox(height: 16.spMin),
        Text(
          'No Order History',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: 8.spMin),
        Text(
          'Your completed and cancelled orders\nwill appear here',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
      ],
    ),
  );

  if (useViewportHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight == double.infinity) {
          final screenHeight = MediaQuery.sizeOf(context).height;
          final topPadding = MediaQuery.of(context).padding.top;
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          final viewportHeight =
              (screenHeight - topPadding - bottomPadding) * 0.7;

          return SizedBox(
            height: viewportHeight,
            child: Center(child: content),
          );
        }
        return Center(child: content);
      },
    );
  }

  return Center(child: content);
}
