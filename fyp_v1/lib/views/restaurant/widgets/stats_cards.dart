import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../view models/controllers/vendor_analytics_view_model.dart';

/// A 2x2 grid of KPI tiles. Reactive — values update instantly when
/// [VendorAnalyticsController] refreshes.
class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = Get.put(VendorAnalyticsController());
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.payments_rounded,
                  label: 'Revenue',
                  value:
                      '\$${analytics.totalRevenue.value.toStringAsFixed(0)}',
                  accent: kPrimary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _Tile(
                  icon: Icons.receipt_long_rounded,
                  label: 'Orders',
                  value: analytics.totalOrders.value.toString(),
                  accent: kTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.today_rounded,
                  label: 'Today',
                  value: analytics.todayOrders.value.toString(),
                  accent: kSecondary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _Tile(
                  icon: Icons.hourglass_top_rounded,
                  label: 'Pending',
                  value: analytics.pendingOrders.value.toString(),
                  accent: kRed,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.check_circle_outline,
                  label: 'Delivered',
                  value: analytics.deliveredOrders.value.toString(),
                  accent: kPrimary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _Tile(
                  icon: Icons.cancel_outlined,
                  label: 'Cancelled',
                  value: analytics.cancelledOrders.value.toString(),
                  accent: kRed,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _Tile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: accent, size: 20.spMin),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 10.h),
          ReuseableText(
            text: value,
            fontSize: 20.spMin,
            fontWeight: FontWeight.w800,
            textColor: kDark,
          ),
          SizedBox(height: 2.h),
          ReuseableText(
            text: label,
            fontSize: 11.spMin,
            fontWeight: FontWeight.w500,
            textColor: kGray,
          ),
        ],
      ),
    );
  }
}
