import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class PaymentMethodSelector extends StatelessWidget {
  final bool cashEnabled;
  final bool onlineEnabled;
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.cashEnabled,
    required this.onlineEnabled,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final methods = <_PaymentMethodData>[
      if (onlineEnabled)
        _PaymentMethodData(
          icon: Icons.add,
          title: 'Add new card',
          value: 'online',
        ),
      if (cashEnabled)
        _PaymentMethodData(
          icon: Icons.payments_outlined,
          title: 'Cash',
          value: 'cash',
        ),
    ];

    if (methods.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        children: [
          for (int i = 0; i < methods.length; i++) ...[
            _PaymentOptionTile(
              icon: methods[i].icon,
              title: methods[i].title,
              isSelected: selectedMethod == methods[i].value,
              isFirst: i == 0,
              isLast: i == methods.length - 1,
              onTap: () => onMethodChanged(methods[i].value),
            ),
            if (i < methods.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: colors.divider,
                indent: 16.spMin,
                endIndent: 16.spMin,
              ),
          ],
        ],
      ),
    );
  }
}

class _PaymentMethodData {
  final IconData icon;
  final String title;
  final String value;

  const _PaymentMethodData({
    required this.icon,
    required this.title,
    required this.value,
  });
}

class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 14.spMin),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? Radius.circular(AppSizes.radiusMd) : Radius.zero,
            bottom: isLast ? Radius.circular(AppSizes.radiusMd) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.primary, size: 22.spMin),
            SizedBox(width: 14.spMin),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Radio indicator
            Container(
              width: 20.spMin,
              height: 20.spMin,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 11.spMin,
                        height: 11.spMin,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
