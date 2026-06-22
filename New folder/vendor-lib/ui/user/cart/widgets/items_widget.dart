import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food/config/widgets/app_network_image.dart';
import 'package:food/config/widgets/price_widget.dart';
import 'package:food/ui/user/food/widgets/widgets.dart';
import '../../../../model/cart/cart_model.dart';
import 'qty_widget.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final String currencySymbol;
  final VoidCallback? onDelete;
  final VoidCallback? onDismissed;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool showQuantityControls;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.currencySymbol,
    this.onDelete,
    this.onDismissed,
    this.onIncrement,
    this.onDecrement,
    this.showQuantityControls = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardContent = _buildCard(colors);

    // When used in exit animation, skip Slidable wrapper
    if (onDelete == null && onDismissed == null) {
      return cardContent;
    }

    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const StretchMotion(),
        dismissible: onDismissed != null
            ? DismissiblePane(onDismissed: () => onDismissed!())
            : null,
        children: [
          CustomSlidableAction(
            padding: EdgeInsets.zero,
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.transparent,
            child: Container(
              height: 80.spMin + 12,
              decoration: BoxDecoration(
                color: colors.error,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 22.spMin,
              ),
            ),
          ),
        ],
      ),
      child: cardContent,
    );
  }

  Widget _buildCard(ThemeColors colors) {
    return Card(
      margin: showQuantityControls ? null : EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.all(6.spMin),
        color: colors.card,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  color: colors.scaffoldBackground,
                ),
                child: AppNetworkImage(
                  imageUrl: item.displayImage,
                  width: 80.spMin,
                  height: 80.spMin,
                  placeholder: Container(
                    width: 80.spMin,
                    height: 80.spMin,
                    color: colors.scaffoldBackground,
                    child: Icon(Icons.fastfood, color: colors.textSecondary),
                  ),
                  errorWidget: Container(
                    width: 80.spMin,
                    height: 80.spMin,
                    color: colors.scaffoldBackground,
                    child: Icon(Icons.fastfood, color: colors.textSecondary),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.spMin),

            // Product Details
            Expanded(
              child: Column(
                spacing: 3.spMin,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    spacing: 8.spMin,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _iconText(
                        (item.product?.rating ?? 0.0).toStringAsFixed(1),
                        Icons.star_rounded,
                        12.spMin,
                        Colors.amber,
                        colors.textSecondary,
                      ),
                      _iconText(
                        item.product?.time ?? '0 min',
                        Icons.access_time_rounded,
                        10.spMin,
                        colors.textSecondary,
                        colors.textSecondary,
                      ),
                    ],
                  ),
                  if (item.additives.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: item.additives.map((a) {
                          return Container(
                            margin: EdgeInsets.only(right: 4.spMin),
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.spMin,
                              vertical: 2.spMin,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusXs,
                              ),
                            ),
                            child: Text(
                              a.title,
                              style: AppTextStyles.buttonSmall.copyWith(
                                color: colors.primary,
                                fontSize: 9.spMin,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  PriceText(
                    price: item.totalPrice,
                    animation: PriceAnimation.flipY,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.spMin),

            // Quantity Controls or Badge
            if (showQuantityControls)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  height: 70.spMin,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QtyButton(
                        icon: Icons.add,
                        onTap: () => onIncrement?.call(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.spMin),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            '${item.quantity}',
                            key: ValueKey(item.quantity),
                            style: AppTextStyles.buttonLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      QtyButton(
                        icon: Icons.remove,
                        onTap: () => onDecrement?.call(),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                margin: EdgeInsets.only(right: 8.spMin),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.spMin,
                  vertical: 5.spMin,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                ),
                child: Text(
                  'x${item.quantity}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _iconText(
  String label,
  IconData icon,
  double iconSize,
  Color iconColor,
  Color txtColor,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, size: iconSize, color: iconColor),
      SizedBox(width: 2.spMin),
      Text(label, style: AppTextStyles.bodyMedium.copyWith(color: txtColor)),
    ],
  );
}
