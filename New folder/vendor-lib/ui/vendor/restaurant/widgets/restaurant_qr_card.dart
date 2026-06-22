import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../config/config.dart';
import '../../../../utils/toast_utils.dart';

/// Displays a printable QR code for a restaurant. Vendors can show this in
/// their store, on tables, or on take-away packaging so customers can open
/// the restaurant page directly via the in-app scanner.
class RestaurantQrCard extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;
  final String? restaurantCode;

  const RestaurantQrCard({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantCode,
  });

  /// QR payload format: prefixed with `RST-` so the scanner can detect a
  /// restaurant QR vs other QR types. The backend strips the prefix and
  /// resolves either by `_id` or short `code`.
  String get _payload => 'RST-$restaurantId';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(20.spMin),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.spMin),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.qr_code_2_rounded,
                  color: colors.primary,
                  size: 18.spMin,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant QR Code',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'Customers can scan this to open your menu',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // QR
          Container(
            padding: EdgeInsets.all(14.spMin),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: QrImageView(
              data: _payload,
              version: QrVersions.auto,
              size: 200.spMin,
              backgroundColor: Colors.white,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: colors.primary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // Restaurant name
          Text(
            restaurantName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          if (restaurantCode != null && restaurantCode!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              'Code: $restaurantCode',
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: _payload));
                    if (context.mounted) {
                      ToastUtils.showSuccess(
                        context,
                        message: 'QR code copied',
                      );
                    }
                  },
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 16.spMin,
                    color: colors.primary,
                  ),
                  label: Text(
                    'Copy',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showFullScreen(context),
                  icon: Icon(
                    Icons.fullscreen_rounded,
                    size: 16.spMin,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Show Big',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16.spMin),
          child: Container(
            padding: EdgeInsets.all(24.spMin),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  restaurantName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (restaurantCode != null && restaurantCode!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    restaurantCode!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                      letterSpacing: 1,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                QrImageView(
                  data: _payload,
                  version: QrVersions.auto,
                  size: 280,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFFFF6B35),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Scan to open this restaurant in the app',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
