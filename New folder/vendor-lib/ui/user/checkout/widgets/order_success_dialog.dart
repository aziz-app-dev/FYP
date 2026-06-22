import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/config/widgets/app_btn.dart';

import '../../../../config/config.dart';
import '../../../../repo/user/order/order_repo.dart';
import '../../../../routes/route_name.dart';
import '../../../../services/session/session_manger.dart';

class OrderSuccessDialog {
  static void show({
    required BuildContext context,
    required String orderId,
    required double total,
  }) {
    final colors = context.colors;
    final currencySymbol = SessionManager().currencySymbol;
    // Capture navigator before any async gap
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius3Xxl),
        ),
        child: Container(
          padding: EdgeInsets.all(24.spMin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.spMin,
                height: 80.spMin,
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: colors.success,
                  size: 48.spMin,
                ),
              ),
              SizedBox(height: 20.spMin),
              Text(
                'Order Placed!',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 8.spMin),
              Text(
                'Your order has been placed successfully',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.spMin),
              Container(
                padding: EdgeInsets.all(16.spMin),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Text(
                          '#${orderId.length >= 8 ? orderId.substring(orderId.length - 8).toUpperCase() : orderId.toUpperCase()}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.spMin),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Text(
                          '$currencySymbol${total.toStringAsFixed(2)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.spMin),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      height: 40.spMin,
                      borderColor: colors.primary,
                      borderWidth: 1,
                      backgroundColor: Colors.transparent,
                      text: 'Home',
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // Replace entire stack with fresh MainScreen (defaults to Home tab)
                        navigator.pushNamedAndRemoveUntil(
                          RouteName.mainScreen,
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12.spMin),
                  Expanded(
                    child: AppButton(
                      height: 40.spMin,
                      text: 'Track Order',
                      onPressed: () async {
                        // Close the dialog first
                        Navigator.of(ctx).pop();

                        // Fetch order, then navigate
                        try {
                          final token = await SessionManager().getToken();
                          if (token != null) {
                            final order = await OrderRepo().getOrderById(
                              orderId,
                              token,
                            );
                            // Replace stack with fresh MainScreen, then push tracking on top
                            navigator.pushNamedAndRemoveUntil(
                              RouteName.mainScreen,
                              (route) => false,
                            );
                            navigator.pushNamed(
                              RouteName.orderTracking,
                              arguments: order,
                            );
                          }
                        } catch (_) {
                          // If fetch fails, go to fresh MainScreen (Home tab)
                          navigator.pushNamedAndRemoveUntil(
                            RouteName.mainScreen,
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
