import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/widgets/app_network_image.dart';

import '../../../../config/config.dart';
import '../../../../config/widgets/price_widget.dart';
import '../../../../model/home/home_model.dart';

class RecentOrdersSectionWidget extends StatelessWidget {
  final List<RecentOrderItem> orders;
  final String title;
  final VoidCallback? onViewAll;

  const RecentOrdersSectionWidget({
    super.key,
    required this.orders,
    this.title = "Recent Orders",
    this.onViewAll,
  });

  Color _statusColor(ThemeColors colors, String? status) {
    switch (status) {
      case 'Delivery':
      case 'Completed':
        return colors.success;
      case 'Out For Delivery':
        return colors.info;
      case 'Preparing':
      case 'Placed':
        return colors.warning;
      case 'Ready':
        return colors.primary;
      case 'Cancelled':
        return colors.error;
      default:
        return colors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  "View All",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.spMin),
        // Horizontal list of order cards
        SizedBox(
          height: 130.spMin,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: orders.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.spMin),
            itemBuilder: (context, index) {
              return _RecentOrderCard(
                order: orders[index],
                statusColor: _statusColor(colors, orders[index].orderStatus),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentOrderCard extends StatelessWidget {
  final RecentOrderItem order;
  final Color statusColor;

  const _RecentOrderCard({required this.order, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final restaurant = order.restaurant;
    final firstFood = order.items?.isNotEmpty == true
        ? order.items!.first
        : null;

    return Container(
      width: 220.spMin,
      padding: EdgeInsets.all(10.spMin),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant info row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.spMin),
                child: AppNetworkImage(
                  imageUrl: restaurant?.logoUrl ?? '',
                  width: 32.spMin,
                  height: 32.spMin,
                  fit: BoxFit.cover,
                  placeholder: Container(
                    width: 32.spMin,
                    height: 32.spMin,
                    color: colors.surface,
                    child: Icon(
                      Icons.restaurant,
                      size: 16.spMin,
                      color: colors.primary,
                    ),
                  ),
                  errorWidget: Container(
                    width: 32.spMin,
                    height: 32.spMin,
                    color: colors.surface,
                    child: Icon(
                      Icons.restaurant,
                      size: 16.spMin,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.spMin),
              Expanded(
                child: Text(
                  restaurant?.title ?? "Restaurant",
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.spMin,
                  vertical: 2.spMin,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(6.spMin),
                ),
                child: Text(
                  _statusLabel(order.orderStatus),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.spMin,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.spMin),
          // Food item preview
          if (firstFood?.food != null)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.spMin),
                  child: AppNetworkImage(
                    imageUrl: firstFood!.food!.imageUrl ?? "",
                    width: 36.spMin,
                    height: 36.spMin,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      width: 36.spMin,
                      height: 36.spMin,
                      color: colors.shimmerBase,
                      child: Icon(
                        Icons.fastfood,
                        size: 16.spMin,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.spMin),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstFood.food!.title ?? "",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if ((order.itemCount ?? 0) > 1)
                        Text(
                          "+${(order.itemCount ?? 1) - 1} more items",
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colors.textSecondary,
                            fontSize: 9.spMin,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          const Spacer(),
          // Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${order.itemCount ?? 0} item${(order.itemCount ?? 0) > 1 ? 's' : ''}",
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              PriceText(
                price: order.grandTotal ?? 0,
                fontWeight: FontWeight.w700,
                fontSize: 12.spMin,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'Delivery':
        return 'Delivered';
      case 'Out For Delivery':
        return 'On the way';
      default:
        return status ?? 'Pending';
    }
  }
}
