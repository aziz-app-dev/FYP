import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../view models/controllers/vendor_analytics_view_model.dart';

/// The 10 most recent cancelled orders, shown as a compact panel
/// on the restaurant dashboard.
class CancelledOrdersCard extends StatelessWidget {
  const CancelledOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = Get.put(VendorAnalyticsController());
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cancel_outlined, color: kRed, size: 18.spMin),
              SizedBox(width: 6.w),
              ReuseableText(
                text: 'Cancelled Orders',
                fontSize: 13.spMin,
                fontWeight: FontWeight.w700,
                textColor: kDark,
              ),
              const Spacer(),
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: kRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: ReuseableText(
                      text: '${analytics.cancelledOrders.value}',
                      fontSize: 11.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: kRed,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final items = analytics.recentCancelled;
            if (items.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: ReuseableText(
                    text: 'No cancelled orders — nice!',
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w400,
                    textColor: kGray,
                  ),
                ),
              );
            }
            return Column(
              children: items.map((o) {
                final dt = o.createdAt;
                final when = dt == null ? '—' : _relativeDay(dt);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: kRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReuseableText(
                              text:
                                  '#${o.id.length >= 6 ? o.id.substring(o.id.length - 6) : o.id}',
                              fontSize: 12.spMin,
                              fontWeight: FontWeight.w700,
                              textColor: kDark,
                            ),
                            ReuseableText(
                              text: '$when · ${o.orderItems.length} item(s)',
                              fontSize: 10.spMin,
                              fontWeight: FontWeight.w400,
                              textColor: kGray,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      ReuseableText(
                        text: '\$${o.grandTotal.toStringAsFixed(0)}',
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w700,
                        textColor: kRed,
                      ),
                      SizedBox(width: 8.w),
                      // Undo = restore to Pending.
                      GestureDetector(
                        onTap: () async {
                          final ok = await _confirmUndo();
                          if (ok == true) {
                            await analytics.undoCancel(o.id);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: kPrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.undo_rounded,
                                  size: 13.spMin, color: kPrimary),
                              SizedBox(width: 3.w),
                              ReuseableText(
                                text: 'Undo',
                                fontSize: 10.spMin,
                                fontWeight: FontWeight.w700,
                                textColor: kPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Future<bool?> _confirmUndo() {
    return Get.dialog<bool>(
      Dialog(
        backgroundColor: kWhite,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimary.withValues(alpha: 0.12),
                ),
                child: Icon(Icons.undo_rounded,
                    color: kPrimary, size: 28.spMin),
              ),
              SizedBox(height: 16.h),
              ReuseableText(
                text: 'Restore this order ?',
                fontSize: 16.spMin,
                fontWeight: FontWeight.w700,
                textColor: kDark,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              ReuseableText(
                text:
                    'The order will be moved back to New Orders and will need to be processed again.',
                fontSize: 12.spMin,
                fontWeight: FontWeight.w400,
                textColor: kGray,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kGray.withValues(alpha: 0.4),
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: ReuseableText(
                          text: 'Keep Cancelled',
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w600,
                          textColor: kDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: true),
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: ReuseableText(
                          text: 'Yes, restore',
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
          ),
        ),
      ),
    );
  }

  String _relativeDay(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
