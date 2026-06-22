import 'widgets.dart';

Widget _infoItem({
  required IconData icon,
  required Color iconColor,
  required String text,
  required ThemeColors colors,
  Widget? trailing,
  bool flexible = false,
}) {
  final textWidget = Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
  );

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: iconColor, size: 18.spMin),
      SizedBox(width: 4.spMin),
      if (flexible) Flexible(child: textWidget) else textWidget,
      if (trailing != null) ...[SizedBox(width: 4.spMin), trailing],
    ],
  );
}

List<Widget> _buildInfoItems(
  BuildContext context,
  FoodDetails food,
  ThemeColors colors,
) {
  final restaurantAddress = food.restaurant?.coords?.address;
  final hasAddress =
      restaurantAddress != null && restaurantAddress.trim().isNotEmpty;

  return [
    GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.productReviews,
          arguments: <String, String>{
            'productId': food.id ?? '',
            'ratingType': 'Food',
          },
        );
      },
      child: _infoItem(
        icon: Icons.star,
        iconColor: colors.star,
        text: food.rating?.toStringAsFixed(1) ?? '0.0',
        trailing: food.ratingCount != null
            ? Text(
                '(${food.ratingCount})',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              )
            : null,
        colors: colors,
      ),
    ),
    _infoItem(
      icon: Icons.access_time,
      iconColor: colors.iconSecondary,
      text: food.time ?? '15-20 min',
      colors: colors,
    ),
    if (food.calories != null)
      _infoItem(
        icon: Icons.local_fire_department,
        iconColor: colors.warning,
        text: '${food.calories} cal',
        colors: colors,
      ),
    if (hasAddress)
      _infoItem(
        icon: Icons.location_on_outlined,
        iconColor: colors.iconSecondary,
        text: restaurantAddress,
        colors: colors,
        flexible: true,
      ),
  ];
}

/// Style 1: Spaced evenly with vertical dividers
class FoodInfoRow extends StatelessWidget {
  final FoodDetails food;

  const FoodInfoRow({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final items = _buildInfoItems(context, food, colors);

    // Wrap address item in Flexible for Row layout
    final rowItems = items.map((item) {
      if (item is Row && item.children.any((c) => c is Flexible)) {
        return Flexible(child: item);
      }
      return item;
    }).toList();

    final children = <Widget>[];
    for (int i = 0; i < rowItems.length; i++) {
      if (i > 0) {
        children.add(
          Container(width: 1, height: 16.spMin, color: colors.border),
        );
      }
      children.add(rowItems[i]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}

/// Style 2: Column layout — title label on top, icon + value below
class FoodInfoRow2 extends StatelessWidget {
  final FoodDetails food;

  const FoodInfoRow2({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final restaurantAddress = food.restaurant?.coords?.address;
    final hasAddress =
        restaurantAddress != null && restaurantAddress.trim().isNotEmpty;

    return Wrap(
      spacing: 22.spMin,
      runSpacing: 8.spMin,
      alignment: WrapAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteName.productReviews,
              arguments: <String, String>{
                'productId': food.id ?? '',
                'ratingType': 'Food',
              },
            );
          },
          child: _infoColumn(
            label: 'Rating',
            icon: Icons.star,
            value: food.rating?.toStringAsFixed(1) ?? '0.0',
            colors: colors,
          ),
        ),
        _infoColumn(
          label: 'Time',
          icon: Icons.access_time,
          value: food.time ?? '15-20 min',
          colors: colors,
        ),
        if (food.calories != null)
          _infoColumn(
            label: 'Calories',
            icon: Icons.local_fire_department,
            value: '${food.calories} cal',
            colors: colors,
          ),
        if (hasAddress)
          _infoColumn(
            label: 'Location',
            icon: Icons.location_on_outlined,
            value: restaurantAddress,
            colors: colors,
          ),
      ],
    );
  }

  Widget _infoColumn({
    required String label,
    required IconData icon,
    required String value,
    required ThemeColors colors,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 6.spMin,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4.spMin,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 15.spMin),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Style 3: Badge pills - each info as a separate chip
class FoodInfoRow3 extends StatelessWidget {
  final FoodDetails food;

  const FoodInfoRow3({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final items = _buildInfoItems(context, food, colors);

    return Wrap(
      spacing: 8.spMin,
      runSpacing: 8.spMin,
      children: items.map((item) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.spMin,
            vertical: 6.spMin,
          ),
          decoration: BoxDecoration(
            color: colors.chipBackground,
            borderRadius: BorderRadius.circular(50),
          ),
          child: item,
        );
      }).toList(),
    );
  }
}
