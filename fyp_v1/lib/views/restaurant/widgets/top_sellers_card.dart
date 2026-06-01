import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/app_network_image.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../view models/controllers/vendor_analytics_view_model.dart';

/// Top 5 best-selling foods (by total quantity ordered across delivered
/// orders). Rendered as a podium-style ranked list.
class TopSellersCard extends StatelessWidget {
  const TopSellersCard({super.key});

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
              Icon(Icons.trending_up_rounded,
                  color: kPrimary, size: 18.spMin),
              SizedBox(width: 6.w),
              ReuseableText(
                text: 'Top Sellers',
                fontSize: 13.spMin,
                fontWeight: FontWeight.w700,
                textColor: kDark,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final items = analytics.topSellers;
            if (items.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Center(
                  child: ReuseableText(
                    text: 'No delivered orders yet',
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w400,
                    textColor: kGray,
                  ),
                ),
              );
            }
            return Column(
              children: List.generate(items.length, (i) {
                final s = items[i];
                final rankColor = _rankColor(i);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    children: [
                      // Rank badge
                      Container(
                        width: 26.w,
                        height: 26.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: rankColor.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: ReuseableText(
                          text: '#${i + 1}',
                          fontSize: 10.spMin,
                          fontWeight: FontWeight.w700,
                          textColor: rankColor,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      AppNetworkImage(
                        imageUrl: s.imageUrl.isEmpty ? null : s.imageUrl,
                        width: 36.w,
                        height: 36.w,
                        borderRadius: BorderRadius.circular(6.r),
                        backgroundColor: kOffWhite,
                        fallbackIcon: Icons.fastfood,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReuseableText(
                              text: s.title,
                              fontSize: 12.spMin,
                              fontWeight: FontWeight.w600,
                              textColor: kDark,
                              overflow: TextOverflow.ellipsis,
                            ),
                            ReuseableText(
                              text: '${s.qty} sold',
                              fontSize: 10.spMin,
                              fontWeight: FontWeight.w400,
                              textColor: kGray,
                            ),
                          ],
                        ),
                      ),
                      ReuseableText(
                        text: '\$${s.revenue.toStringAsFixed(0)}',
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w700,
                        textColor: kPrimary,
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Color _rankColor(int idx) {
    switch (idx) {
      case 0:
        return const Color(0xFFFFC107); // gold
      case 1:
        return const Color(0xFFB0B0B0); // silver
      case 2:
        return const Color(0xFFCD7F32); // bronze
      default:
        return kGray;
    }
  }
}
