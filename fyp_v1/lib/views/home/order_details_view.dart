import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../models/order/vendor_order_model.dart';
import '../../view models/controllers/vendor_order_view_model.dart';

/// Full order details for the vendor, opened by tapping a tile on the
/// home order tabs. Shows the full bill breakdown, each food as its
/// own card, delivery address, and status-transition actions matching
/// the tab the order came from.
class VendorOrderDetailsScreen extends StatelessWidget {
  final VendorOrder order;

  /// Action buttons inherited from the caller tab (Ready tab sends
  /// "Hand to Driver" + "Self-Deliver"; Pending tab sends
  /// "Accept & Prepare" + "Cancel"; etc.). Either may be null on
  /// terminal tabs (Delivered / Cancelled).
  final String? primaryLabel;
  final String? primaryNextStatus;
  final String? secondaryLabel;
  final String? secondaryNextStatus;

  /// Controller tag — used to refetch the originating tab after a
  /// status change so the UI stays in sync.
  final String tabStatus;

  const VendorOrderDetailsScreen({
    super.key,
    required this.order,
    required this.tabStatus,
    this.primaryLabel,
    this.primaryNextStatus,
    this.secondaryLabel,
    this.secondaryNextStatus,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<VendorOrderController>(tag: tabStatus);
    final createdLabel = _formatCreated(order.createdAt);

    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'Order Details',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 120.h),
        children: [
          // Header card
          _card(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReuseableText(
                      text:
                          '#${order.id.length >= 8 ? order.id.substring(order.id.length - 8) : order.id}',
                      fontSize: 15.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: kDark,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: _statusColor(order.orderStatus),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: ReuseableText(
                        text: order.orderStatus,
                        fontSize: 11.spMin,
                        fontWeight: FontWeight.w700,
                        textColor: kLightWhite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ReuseableText(
                  text: createdLabel,
                  fontSize: 11.spMin,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Items — each food as its own card.
          _sectionLabel('Items (${order.orderItems.length})'),
          ...order.orderItems.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _FoodCard(item: item),
              )),
          SizedBox(height: 6.h),

          // Bill summary
          _sectionLabel('Bill'),
          _card(
            padding: EdgeInsets.all(14.r),
            child: Column(
              children: [
                _billRow('Subtotal',
                    '\$${order.orderTotal.toStringAsFixed(2)}'),
                SizedBox(height: 6.h),
                _billRow('Delivery fee',
                    '\$${order.deliveryFee.toStringAsFixed(2)}'),
                SizedBox(height: 6.h),
                _billRow(
                  'Payment',
                  '${order.paymentMethod ?? '—'} · ${order.paymentStatus}',
                ),
                Divider(height: 20.h),
                _billRow(
                  'Grand total',
                  '\$${order.grandTotal.toStringAsFixed(2)}',
                  bold: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Delivery address
          _sectionLabel('Delivery'),
          _card(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: kGray, size: 22.spMin),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseableText(
                        text: 'Recipient coords',
                        fontSize: 11.spMin,
                        fontWeight: FontWeight.w500,
                        textColor: kGray,
                      ),
                      SizedBox(height: 2.h),
                      ReuseableText(
                        text: order.recipientCoords.isEmpty
                            ? '—'
                            : order.recipientCoords
                                .map((c) => c.toStringAsFixed(4))
                                .join(', '),
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w600,
                        textColor: kDark,
                      ),
                      SizedBox(height: 8.h),
                      ReuseableText(
                        text: 'Restaurant address',
                        fontSize: 11.spMin,
                        fontWeight: FontWeight.w500,
                        textColor: kGray,
                      ),
                      SizedBox(height: 2.h),
                      ReuseableText(
                        text: order.restaurantAddress.isEmpty
                            ? '—'
                            : order.restaurantAddress,
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w600,
                        textColor: kDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Sticky action bar (only when the tab has transitions available).
      bottomNavigationBar: (primaryNextStatus == null &&
              secondaryNextStatus == null)
          ? null
          : SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border(top: BorderSide(color: kOffWhite)),
                ),
                child: Row(
                  children: [
                    if (secondaryNextStatus != null) ...[
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await controller.updateStatus(
                                order.id, secondaryNextStatus!);
                            // Pop with GetX — no BuildContext across async.
                            Get.back();
                          },
                          child: Container(
                            height: 44.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kOffWhite,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: ReuseableText(
                              text: secondaryLabel ?? '',
                              fontSize: 13.spMin,
                              fontWeight: FontWeight.w600,
                              textColor: kRed,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                    if (primaryNextStatus != null)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await controller.updateStatus(
                                order.id, primaryNextStatus!);
                            Get.back();
                          },
                          child: Container(
                            height: 44.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: ReuseableText(
                              text: primaryLabel ?? 'Advance',
                              fontSize: 13.spMin,
                              fontWeight: FontWeight.w700,
                              textColor: kLightWhite,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kOffWhite),
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
        child: ReuseableText(
          text: text,
          fontSize: 12.spMin,
          fontWeight: FontWeight.w700,
          textColor: kGray,
        ),
      );

  Widget _billRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReuseableText(
          text: label,
          fontSize: bold ? 13.spMin : 12.spMin,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          textColor: bold ? kDark : kGray,
        ),
        ReuseableText(
          text: value,
          fontSize: bold ? 14.spMin : 12.spMin,
          fontWeight: FontWeight.w700,
          textColor: bold ? kPrimary : kDark,
        ),
      ],
    );
  }

  String _formatCreated(DateTime? dt) {
    if (dt == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour12 = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final mm = dt.minute.toString().padLeft(2, '0');
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year} · ${hour12.toString().padLeft(2, '0')}:$mm $ampm';
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

/// A single item card — thumbnail + title + qty + additives + price.
class _FoodCard extends StatelessWidget {
  final VendorOrderItem item;
  const _FoodCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            imageUrl: item.foodImageUrl.isEmpty
                ? null
                : item.foodImageUrl.first,
            width: 64.w,
            height: 64.w,
            borderRadius: BorderRadius.circular(10.r),
            fallbackIcon: Icons.fastfood,
            backgroundColor: kOffWhite,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: item.foodTitle,
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w700,
                  textColor: kDark,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: ReuseableText(
                        text: 'x${item.quantity}',
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w700,
                        textColor: kPrimary,
                      ),
                    ),
                    if (item.foodTime.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      ReuseableText(
                        text: item.foodTime,
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w400,
                        textColor: kGray,
                      ),
                    ],
                  ],
                ),
                if (item.additives.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.h,
                    children: item.additives
                        .map((a) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: kOffWhite,
                                borderRadius:
                                    BorderRadius.circular(6.r),
                              ),
                              child: ReuseableText(
                                text: a,
                                fontSize: 9.spMin,
                                fontWeight: FontWeight.w500,
                                textColor: kGray,
                              ),
                            ))
                        .toList(),
                  ),
                ],
                if (item.instruction.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit_note_rounded,
                          color: kGray, size: 14.spMin),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ReuseableText(
                          text: item.instruction,
                          fontSize: 10.spMin,
                          fontWeight: FontWeight.w400,
                          textColor: kGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ReuseableText(
            text: '\$${item.price.toStringAsFixed(2)}',
            fontSize: 13.spMin,
            fontWeight: FontWeight.w800,
            textColor: kPrimary,
          ),
        ],
      ),
    );
  }
}
