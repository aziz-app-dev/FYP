import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class TimelineStepWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isLast;

  const TimelineStepWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isActive ? colors.primary : colors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 3),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: .4),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: isActive
                  ? Icon(Icons.check, size: 14.spMin, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40.h,
                color: isActive
                    ? colors.primary.withValues(alpha: .5)
                    : colors.divider,
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? colors.textPrimary : colors.textTertiary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isActive ? colors.textSecondary : colors.textTertiary,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }
}
