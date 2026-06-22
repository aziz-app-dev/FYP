import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';
import '../../../../config/widgets/price_widget.dart';

class PriceRow extends StatelessWidget {
  final String label;
  final double price;
  final ThemeColors colors;
  final Color? valueColor;
  final String prefix;

  const PriceRow({
    super.key,
    required this.label,
    required this.price,
    required this.colors,
    this.valueColor,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
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
          animation: PriceAnimation.flipY,
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
