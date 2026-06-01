import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/app_network_image.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../common/utils/utils.dart';
import '../../../models/restaurant/restaurant_model.dart';
import '../../../view models/controllers/vendor_analytics_view_model.dart';
import '../../../view models/controllers/vendor_restaurant_view_model.dart';
import '../ratings_details_view.dart';

/// Redesigned restaurant header — wide cover image with an overlapping
/// circular logo (with a verified-badge overlay), restaurant name +
/// address below, plus a KPI row (Min. delivery · Delivery time · Rating).
///
/// Tapping the rating stat pushes the full RatingsDetailsScreen.
class RestaurantCoverHeader extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantCoverHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final analytics = Get.put(VendorAnalyticsController());
    final vendor = Get.put(VendorRestaurantController());
    final isVerified = restaurant.verification == 'Verified';

    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: kOffWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // COVER + overlapping logo.
          SizedBox(
            height: 170.h,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Cover image.
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.r),
                      topRight: Radius.circular(18.r),
                    ),
                    child: AppNetworkImage(
                      imageUrl: restaurant.imageUrl,
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.photo_outlined,
                      backgroundColor: kOffWhite,
                    ),
                  ),
                ),
                // Tappable open-sign — greyscaled + dimmed when Closed.
                Positioned(
                  top: 0.h,
                  right: 12.spMin,
                  child: Obx(() {
                    final r = vendor.active ?? restaurant;
                    final isOpen = r.isAvailable;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (!isVerified) {
                          Utils.showWarning(
                            'Not verified',
                            'Your restaurant is still under admin review.',
                          );
                          return;
                        }
                        await vendor.toggleAvailability(r.id);
                      },
                      // Plain image — no circular white chip / shadow.
                      child: Opacity(
                        opacity: isOpen ? 1.0 : 0.35,
                        child: ColorFiltered(
                          colorFilter: isOpen
                              ? const ColorFilter.mode(
                                  Colors.transparent, BlendMode.multiply)
                              : const ColorFilter.matrix(<double>[
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                          child: Image.asset(
                            'assets/icons8-open-sign-48.png',
                            width: 44.w,
                            height: 44.w,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                // Overlapping circular logo + verified badge.
                Positioned(
                  bottom: -40.r,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: kWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AppNetworkAvatar(
                          imageUrl: restaurant.logoUrl,
                          radius: 36.r,
                          backgroundColor: kOffWhite,
                          fallbackIcon: Icons.storefront,
                        ),
                      ),
                      // if (isVerified)
                      //   Positioned(
                      //     right: 0,
                      //     bottom: 4.r,
                      //     child: Container(
                      //       width: 24.r,
                      //       height: 24.r,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         color: kPrimary,
                      //         shape: BoxShape.circle,
                      //         border: Border.all(color: kWhite, width: 2),
                      //       ),
                      //       child: Icon(
                      //         Icons.verified,
                      //         size: 14.spMin,
                      //         color: kLightWhite,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 48.h),

          // Name + category/address.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ReuseableText(
                        text: restaurant.title,
                        fontSize: 20.spMin,
                        fontWeight: FontWeight.w800,
                        textColor: kDark,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(width: 6.w),
                      Icon(Icons.verified, color: kPrimary, size: 16.spMin),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                ReuseableText(
                  text: restaurant.coords.address.isEmpty
                      ? '—'
                      : restaurant.coords.address,
                  fontSize: 11.spMin,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _stat(
                    icon: Icons.payments_rounded,
                    accent: kPrimary,
                    valueWidget: Obx(() => ReuseableText(
                          text:
                              '\$${analytics.totalRevenue.value.toStringAsFixed(0)}',
                          fontSize: 14.spMin,
                          fontWeight: FontWeight.w800,
                          textColor: kDark,
                        )),
                    label: 'Total Income',
                  ),
                ),
                _divider(),
                Expanded(
                  child: _stat(
                    icon: Icons.schedule_rounded,
                    accent: kSecondary,
                    valueWidget: ReuseableText(
                      text: restaurant.time.isEmpty ? '—' : restaurant.time,
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.w800,
                      textColor: kDark,
                    ),
                    label: 'Prep Time',
                  ),
                ),
                _divider(),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.to(
                        () => RatingsDetailsScreen(
                          restaurantId: restaurant.id,
                          restaurantName: restaurant.title,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: _stat(
                      icon: Icons.star_rounded,
                      accent: kSecondary,
                      valueWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReuseableText(
                            text: restaurant.rating == 0
                                ? '—'
                                : restaurant.rating.toStringAsFixed(1),
                            fontSize: 14.spMin,
                            fontWeight: FontWeight.w800,
                            textColor: kDark,
                          ),
                          SizedBox(width: 3.w),
                          Icon(Icons.chevron_right_rounded,
                              size: 14.spMin, color: kGray),
                        ],
                      ),
                      label: 'Rating',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat({
    required IconData icon,
    required Color accent,
    required Widget valueWidget,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: accent, size: 20.spMin),
        SizedBox(height: 4.h),
        valueWidget,
        SizedBox(height: 2.h),
        ReuseableText(
          text: label,
          fontSize: 10.spMin,
          fontWeight: FontWeight.w500,
          textColor: kGray,
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40.h,
        color: kOffWhite,
      );
}
