// ignore_for_file: unused_local_variable

import '../../../../utils/utils.dart';
import 'widgets.dart';

/// Horizontal quantity selector (used in bottom bar / detail pages)
class QuantitySelectorWidget extends StatelessWidget {
  const QuantitySelectorWidget({
    super.key,
    required this.colors,
    required this.isAtMinQuantity,
    required this.quantity,
    required this.isAtMaxQuantity,
  });

  final ThemeColors colors;
  final bool isAtMinQuantity;
  final int quantity;
  final bool isAtMaxQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.spMin),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: isAtMinQuantity
                ? null
                : () => context.read<FoodDetailsBloc>().add(
                    DecrementQuantityEvent(),
                  ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXs),
              child: Icon(
                Icons.remove,
                size: 20.spMin,
                color: isAtMinQuantity
                    ? colors.iconDisabled
                    : colors.iconPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 20.spMin,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: colors.border,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXs),
            child: Text(
              '$quantity',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 20.spMin,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: colors.border,
            ),
          ),
          InkWell(
            onTap: isAtMaxQuantity
                ? null
                : () => context.read<FoodDetailsBloc>().add(
                    const IncrementQuantityEvent(),
                  ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXs),
              child: Icon(
                Icons.add,
                size: 20.spMin,
                color: isAtMaxQuantity
                    ? colors.iconDisabled
                    : colors.iconPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _quantityButton(
  VoidCallback? onTap,
  Color? color,
  IconData icon,
  double iconSize,
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(4.spMin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      child: Icon(icon, size: iconSize.spMin, color: Colors.white),
    ),
  );
}

/// Vertical quantity selector (used in OneImageWidget2 overlay)
class VerticalQuantitySelector extends StatelessWidget {
  const VerticalQuantitySelector({
    super.key,
    required this.quantity,
    required this.isAtMinQuantity,
    required this.isAtMaxQuantity,
  });

  final int quantity;
  final bool isAtMinQuantity;
  final bool isAtMaxQuantity;

  @override
  Widget build(BuildContext context) {
    final isSmallMob = ScreenUtils.isSmallMob(context);
    final isTablet = ScreenUtils.isTablet(context);
    final isDesktop = ScreenUtils.isDesktop(context);
    final isMobile = !isTablet && !isDesktop;
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.spMin, horizontal: 6.spMin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quantityButton(
            isAtMaxQuantity
                ? null
                : () => context.read<FoodDetailsBloc>().add(
                    const IncrementQuantityEvent(),
                  ),
            isAtMaxQuantity ? Colors.grey[400] : colors.secondary,
            Icons.add,
            isDesktop ? 22 : 18,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.spMin),
            child: Text(
              '$quantity',
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: isDesktop ? 20.spMin : 12.spMin,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          _quantityButton(
            isAtMinQuantity
                ? null
                : () => context.read<FoodDetailsBloc>().add(
                    DecrementQuantityEvent(),
                  ),
            isAtMinQuantity
                ? colors.secondary.withValues(alpha: 0.6)
                : colors.primary,
            Icons.remove,
            isDesktop ? 24 : 18,
          ),
        ],
      ),
    );
  }
}
