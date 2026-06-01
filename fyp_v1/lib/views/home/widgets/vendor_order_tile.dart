import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/app_network_image.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../models/order/vendor_order_model.dart';

/// Single order card used across all vendor tabs.
///
/// `primaryAction` / `secondaryAction` move the order forward/back
/// in the pipeline. Either can be null to hide that button.
class VendorOrderTile extends StatelessWidget {
  final VendorOrder order;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const VendorOrderTile({
    super.key,
    required this.order,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: order id + total + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReuseableText(
                text:
                    '#${order.id.length >= 8 ? order.id.substring(order.id.length - 8) : order.id}',
                fontSize: 12.spMin,
                fontWeight: FontWeight.w700,
                textColor: kDark,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _statusColor(order.orderStatus),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: ReuseableText(
                  text: order.orderStatus,
                  fontSize: 10.spMin,
                  fontWeight: FontWeight.w600,
                  textColor: kLightWhite,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Items
          ...order.orderItems.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    AppNetworkImage(
                      imageUrl: item.foodImageUrl.isEmpty
                          ? null
                          : item.foodImageUrl.first,
                      width: 40.w,
                      height: 40.w,
                      borderRadius: BorderRadius.circular(6.r),
                      fallbackIcon: Icons.fastfood,
                      backgroundColor: kOffWhite,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReuseableText(
                            text: item.foodTitle,
                            fontSize: 12.spMin,
                            fontWeight: FontWeight.w600,
                            textColor: kDark,
                          ),
                          ReuseableText(
                            text: 'Qty: ${item.quantity}',
                            fontSize: 10.spMin,
                            fontWeight: FontWeight.w400,
                            textColor: kGray,
                          ),
                        ],
                      ),
                    ),
                    ReuseableText(
                      text: '\$${item.price.toStringAsFixed(2)}',
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: kPrimary,
                    ),
                  ],
                ),
              )),
          Divider(height: 14.h, color: kOffWhite),
          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReuseableText(
                text: 'Total',
                fontSize: 12.spMin,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
              ReuseableText(
                text: '\$${order.grandTotal.toStringAsFixed(2)}',
                fontSize: 13.spMin,
                fontWeight: FontWeight.w700,
                textColor: kDark,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReuseableText(
                text: 'Payment',
                fontSize: 11.spMin,
                fontWeight: FontWeight.w400,
                textColor: kGray,
              ),
              ReuseableText(
                text:
                    '${order.paymentMethod ?? '—'} · ${order.paymentStatus}',
                fontSize: 11.spMin,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
            ],
          ),
          // Actions
          if (onPrimary != null || onSecondary != null) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                if (onSecondary != null) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: onSecondary,
                      child: Container(
                        height: 34.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kOffWhite,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ReuseableText(
                          text: secondaryLabel ?? '',
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w600,
                          textColor: kRed,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                if (onPrimary != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: onPrimary,
                      child: Container(
                        height: 34.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ReuseableText(
                          text: primaryLabel ?? 'Advance',
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w600,
                          textColor: kLightWhite,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Pending':
        return kSecondary;
      case 'Preparing':
      case 'Ready':
        return kPrimary;
      case 'Out For Delivery':
      case 'Delivering':
        return kTertiary;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return kRed;
      default:
        return kGray;
    }
  }
}
