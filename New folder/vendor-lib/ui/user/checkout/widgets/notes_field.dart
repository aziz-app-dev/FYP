import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class OrderNotesField extends StatelessWidget {
  final TextEditingController controller;

  const OrderNotesField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        border: Border.all(color: colors.divider),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Add any special instructions for your order...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.spMin),
        ),
        style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
      ),
    );
  }
}
