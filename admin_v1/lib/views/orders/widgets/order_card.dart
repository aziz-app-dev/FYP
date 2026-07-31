import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../common/res/components/status_chip.dart';
import '../../../models/order/admin_order_model.dart';

/// Compact order row used on every Orders tab.
class OrderCard extends StatelessWidget {
  final AdminOrder order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  static final _date = DateFormat('dd MMM, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final firstItem =
        order.orderItems.isEmpty ? null : order.orderItems.first;
    final image = (firstItem != null && firstItem.foodImageUrl.isNotEmpty)
        ? firstItem.foodImageUrl.first
        : (order.restaurant.logoUrl.isNotEmpty
            ? order.restaurant.logoUrl
            : null);
    final itemsLabel = order.orderItems
        .map((i) => '${i.quantity}x ${i.foodTitle.isEmpty ? 'item' : i.foodTitle}')
        .join(', ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 54,
                    height: 54,
                    child: image == null
                        ? Container(
                            color: kOffWhite,
                            child: const Icon(Icons.fastfood_rounded,
                                color: kGrayLight),
                          )
                        : CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: kOffWhite,
                              child: const Icon(Icons.fastfood_rounded,
                                  color: kGrayLight),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ReuseableText(
                              text: order.restaurant.title.isEmpty
                                  ? 'Order #${order.id.length > 6 ? order.id.substring(order.id.length - 6) : order.id}'
                                  : order.restaurant.title,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              textColor: kDark,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StatusChip(label: order.orderStatus),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ReuseableText(
                        text: itemsLabel.isEmpty ? 'No items' : itemsLabel,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: kGray,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 14, color: kGrayLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: ReuseableText(
                              text: order.user.username.isEmpty
                                  ? order.user.id
                                  : order.user.username,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: kGray,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ReuseableText(
                  text: 'Rs ${order.grandTotal.toStringAsFixed(0)}',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  textColor: kPrimary,
                ),
                const SizedBox(width: 8),
                ReuseableText(
                  text: order.paymentMethod,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  textColor: kGray,
                ),
                const Spacer(),
                ReuseableText(
                  text: order.createdAt == null
                      ? ''
                      : _date.format(order.createdAt!.toLocal()),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  textColor: kGrayLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
