import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/config/widgets/app_network_image.dart';

import '../../../../config/config.dart';
import '../../../../config/widgets/order_qr_widget.dart';
import '../../../../model/order/order_model.dart';
import '../../../../utils/toast_utils.dart';
import 'timeline_step_widget.dart';

class TrackingBottomSheet extends StatelessWidget {
  final OrderModel order;
  final int currentStep;
  final VoidCallback onCancel;

  const TrackingBottomSheet({
    super.key,
    required this.order,
    required this.currentStep,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 100.h),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: .95),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colors.divider,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),

                // Order info header
                _buildOrderInfoHeader(colors),

                SizedBox(height: 16.h),

                // Driver Info
                if (order.isBeingDelivered && order.driverInfo != null) ...[
                  _buildDriverInfo(context, colors),
                  Divider(height: 32.h, color: colors.divider),
                ],

                // Timeline
                TimelineStepWidget(
                  title: 'Pending',
                  subtitle: 'Your order has been placed',
                  isActive: currentStep >= 0,
                  isLast: false,
                ),
                TimelineStepWidget(
                  title: 'Preparing',
                  subtitle: 'Your food is being prepared',
                  isActive: currentStep >= 1,
                  isLast: false,
                ),
                TimelineStepWidget(
                  title: 'Ready',
                  subtitle: 'Your order is ready',
                  isActive: currentStep >= 2,
                  isLast: false,
                ),
                TimelineStepWidget(
                  title: 'Out for Delivery',
                  subtitle: 'Driver is on the way',
                  isActive: currentStep >= 3,
                  isLast: false,
                ),
                TimelineStepWidget(
                  title: 'Delivered',
                  subtitle: 'Your order has been delivered',
                  isActive: currentStep >= 4,
                  isLast: true,
                ),

                // Show QR Code button
                if (order.verificationCode != null) ...[
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showQrBottomSheet(context, order.verificationCode!, colors),
                      icon: const Icon(Icons.qr_code_rounded),
                      label: const Text('Show QR Code'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.primary),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],

                // Cancel button
                if (order.canCancel) ...[
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: onCancel,
                    child: Text(
                      'Cancel Order',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoHeader(ThemeColors colors) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: AppNetworkImage(
            imageUrl: order.restaurant?.imageUrl ?? '',
            width: 50.w,
            height: 50.w,
            fit: BoxFit.cover,
            placeholder: Container(
              width: 50.w,
              height: 50.w,
              color: colors.surfaceVariant,
              child: Icon(
                Icons.restaurant_rounded,
                color: colors.textTertiary,
              ),
            ),
            errorWidget: Container(
              width: 50.w,
              height: 50.w,
              color: colors.surfaceVariant,
              child: Icon(
                Icons.restaurant_rounded,
                color: colors.textTertiary,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.restaurant?.title ?? 'Restaurant',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${order.totalItems} items',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            order.orderStatus.value,
            style: AppTextStyles.labelSmall.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(BuildContext context, ThemeColors colors) {
    final driver = order.driverInfo!;

    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: colors.surfaceVariant,
          backgroundImage: driver.image != null && driver.image!.isNotEmpty
              ? CachedNetworkImageProvider(driver.image!)
              : null,
          child: driver.image == null || driver.image!.isEmpty
              ? Icon(
                  Icons.person_rounded,
                  color: colors.textSecondary,
                  size: 24.spMin,
                )
              : null,
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver.name ?? 'Driver',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              if (driver.vehicleType != null || driver.vehicleNumber != null)
                Text(
                  '${driver.vehicleType ?? ''} ${driver.vehicleNumber ?? ''}'
                      .trim(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        if (driver.phone != null)
          GestureDetector(
            onTap: () {
              ToastUtils.showInfo(context, message: 'Call ${driver.phone}');
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_rounded,
                color: Colors.white,
                size: 20.spMin,
              ),
            ),
          ),
      ],
    );
  }

  void _showQrBottomSheet(BuildContext context, String code, ThemeColors colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            OrderQrWidget(verificationCode: code),
          ],
        ),
      ),
    );
  }
}
