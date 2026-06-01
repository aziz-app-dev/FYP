import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../view models/controllers/vendor_analytics_view_model.dart';

/// 7-day sales bar chart — no third-party chart package, just animated
/// containers sized relative to the week's max revenue.
///
/// Reactive: rebuilds whenever [VendorAnalyticsController.last7DaysRevenue]
/// changes.
class SalesBarChart extends StatelessWidget {
  const SalesBarChart({super.key});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReuseableText(
                text: 'Sales · Last 7 days',
                fontSize: 13.spMin,
                fontWeight: FontWeight.w700,
                textColor: kDark,
              ),
              Obx(() {
                final total = analytics.last7DaysRevenue
                    .fold<double>(0, (a, b) => a + b);
                return ReuseableText(
                  text: '\$${total.toStringAsFixed(0)}',
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w700,
                  textColor: kPrimary,
                );
              }),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 140.h,
            child: Obx(() {
              final values = analytics.last7DaysRevenue.toList();
              final labels = analytics.last7DayLabels.toList();
              final maxVal = values.fold<double>(
                  0, (m, v) => v > m ? v : m);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (i) {
                  final v = values[i];
                  final ratio = maxVal == 0 ? 0.0 : v / maxVal;
                  final isToday = i == values.length - 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Tooltip-like value above bar (only if > 0)
                          if (v > 0)
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: ReuseableText(
                                text: '\$${v.toStringAsFixed(0)}',
                                fontSize: 9.spMin,
                                fontWeight: FontWeight.w600,
                                textColor: kGray,
                              ),
                            ),
                          AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 350),
                            curve: Curves.easeOut,
                            height:
                                (ratio * 90.h).clamp(4.h, 90.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isToday
                                    ? const [
                                        Color(0xFF30b9b2),
                                        Color(0xFF40F3EA),
                                      ]
                                    : [
                                        kPrimary.withValues(alpha: 0.55),
                                        kPrimary.withValues(alpha: 0.25),
                                      ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(6.r),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          ReuseableText(
                            text: labels[i],
                            fontSize: 10.spMin,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.w400,
                            textColor: isToday ? kPrimary : kGray,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
          SizedBox(height: 6.h),
          Obx(() {
            final avg = analytics.avgOrderValue.value;
            final delivered = analytics.deliveredOrders.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _mini('Delivered', delivered.toString()),
                _mini('Avg Order', '\$${avg.toStringAsFixed(0)}'),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _mini(String label, String value) {
    return Row(
      children: [
        ReuseableText(
          text: label,
          fontSize: 11.spMin,
          fontWeight: FontWeight.w400,
          textColor: kGray,
        ),
        SizedBox(width: 6.w),
        ReuseableText(
          text: value,
          fontSize: 11.spMin,
          fontWeight: FontWeight.w700,
          textColor: kDark,
        ),
      ],
    );
  }
}
