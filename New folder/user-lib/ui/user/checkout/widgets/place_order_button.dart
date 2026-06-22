import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class PlaceOrderButton extends StatelessWidget {
  final String paymentMethod;
  final String currencySymbol;
  final double total;
  final bool isProcessing;
  final VoidCallback onPressed;

  const PlaceOrderButton({
    super.key,
    required this.paymentMethod,
    required this.currencySymbol,
    required this.total,
    required this.isProcessing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: isProcessing ? null : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.spMin),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              paymentMethod == 'online'
                  ? Icons.credit_card
                  : Icons.local_shipping_outlined,
              color: Colors.white,
              size: 20.spMin,
            ),
            SizedBox(width: 8.spMin),
            Text(
              paymentMethod == 'online'
                  ? 'Pay $currencySymbol${total.toStringAsFixed(2)}'
                  : 'Place Order - $currencySymbol${total.toStringAsFixed(2)}',
              style: AppTextStyles.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
