import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config.dart';

class OrderQrWidget extends StatelessWidget {
  final String verificationCode;

  const OrderQrWidget({super.key, required this.verificationCode});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16.spMin),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: QrImageView(
            data: verificationCode,
            version: QrVersions.auto,
            size: 200.spMin,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.circle,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            verificationCode,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textOnPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Show this QR code to verify your order',
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
