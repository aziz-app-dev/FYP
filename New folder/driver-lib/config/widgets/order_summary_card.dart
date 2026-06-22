import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config.dart';
import 'price_widget.dart';

/// A reusable order summary card showing subtotal, delivery fee,
/// tax, discount, and total. Used in both cart and checkout pages.
class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double taxAmount;
  final double discount;
  final double total;
  final String? title;
  final PriceAnimation? priceAnimation;
  final Widget? child;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxAmount,
    required this.discount,
    required this.total,
    this.title,
    this.priceAnimation = PriceAnimation.flipY,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.spMin),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 14.spMin),
          ],

          // Subtotal
          _SummaryRow(
            label: 'Order Amount',
            price: subtotal,
            animation: priceAnimation,
          ),
          SizedBox(height: 10.spMin),

          // Discount
          if (discount > 0) ...[
            _SummaryRow(
              label: 'Promo-code',
              price: discount,
              prefix: '-',
              valueColor: colors.primary,
              animation: priceAnimation,
            ),
            SizedBox(height: 10.spMin),
          ],

          // Delivery Fee
          _SummaryRow(
            label: 'Delivery',
            price: deliveryFee,
            valueColor: deliveryFee == 0 ? colors.success : null,
            animation: priceAnimation,
          ),

          // Tax
          if (taxAmount > 0) ...[
            SizedBox(height: 10.spMin),
            _SummaryRow(
              label: 'Tax',
              price: taxAmount,
              animation: priceAnimation,
            ),
          ],

          SizedBox(height: 14.spMin),

          // Dashed divider
          SizedBox(
            width: double.infinity,
            height: 1,
            child: CustomPaint(
              painter: _DashedLinePainter(
                color: colors.divider.withValues(alpha: 0.5),
              ),
            ),
          ),

          SizedBox(height: 14.spMin),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              PriceText(
                price: total,
                animation: priceAnimation,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontSize: 18.spMin,
                ),
              ),
            ],
          ),

          // Optional action widget (e.g. place order button)
          if (child != null) ...[
            SizedBox(height: 16.spMin),
            child!,
          ],
        ],
      ),
    );
  }
}

/// Internal summary row with label and animated PriceText
class _SummaryRow extends StatelessWidget {
  final String label;
  final double price;
  final String prefix;
  final Color? valueColor;
  final PriceAnimation? animation;

  const _SummaryRow({
    required this.label,
    required this.price,
    this.prefix = '',
    this.valueColor,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        PriceText(
          price: price,
          prefix: prefix,
          animation: animation,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? colors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14.spMin,
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}
