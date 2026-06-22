import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/config.dart';

Widget favoriteEmptyState(
  ThemeColors colors, {
  bool useViewportHeight = false,
}) {
  final content = Padding(
    padding: AppSizes.paddingAllLg,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/lottie/Add to favorites.json',
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
              Icons.favorite_border_rounded,
              size: 70.spMin,
              color: colors.primary,
            ),
          ),
        ),
        SizedBox(height: 16.spMin),
        Text(
          'No Favorites Yet',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: 8.spMin),
        Text(
          'Start adding your favorite foods\nto see them here',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
      ],
    ),
  );

  // For tablet/desktop inside ListView (unbounded height), use viewport calculation
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
