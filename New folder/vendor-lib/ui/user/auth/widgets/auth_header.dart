import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/config.dart';

Widget buildHeader(
  String title,
  String subTitle,
  IconData icon,
  BuildContext context,
) {
  final colors = context.colors;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(12.spMin),
        // width: 60.spMin,
        // height: 60.spMin,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: AppSizes.shadowBlurLg,
              spreadRadius: AppSizes.shadowSpreadSm,
            ),
          ],
        ),
        child: Icon(icon, color: colors.textOnPrimary, size: AppSizes.iconXxl),
      ),

      SizedBox(width: AppSizes.spacingSm),

      /// 👇 IMPORTANT: Expanded gives width constraint
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.displaySmall.copyWith(
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
