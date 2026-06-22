import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class ProcessingOverlay extends StatelessWidget {
  final String paymentMethod;

  const ProcessingOverlay({
    super.key,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.spMin),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: colors.primary),
              SizedBox(height: 16.spMin),
              Text(
                paymentMethod == 'online'
                    ? 'Processing Payment...'
                    : 'Placing Order...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
