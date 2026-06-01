import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/routes/routes_name.dart';
import '../../../common/utils/utils.dart';
import '../../../view models/controllers/vendor_restaurant_view_model.dart';
import 'home_tile_widget.dart';

/// Quick-action row at the top of the vendor home.
/// Food-related tiles require a *verified* restaurant; otherwise we show
/// an explanatory toast and push the vendor to the Restaurant screen
/// so they can see the approval status.
class HomeTiles extends StatelessWidget {
  const HomeTiles({super.key});

  void _goOrRedirect(String route) {
    final vendor = Get.put(VendorRestaurantController());
    final id = vendor.activeId;
    final status = vendor.verificationStatus;

    if (id == null || id.isEmpty) {
      Utils.showWarning(
        'No restaurant',
        'Create a restaurant application first.',
      );
      Get.toNamed(RouteName.restaurantScreen);
      return;
    }
    if (status != 'Verified') {
      Utils.showWarning(
        'Not verified',
        status == 'Rejected'
            ? 'Your application was rejected.'
            : 'Your restaurant is waiting for admin approval.',
      );
      Get.toNamed(RouteName.restaurantScreen);
      return;
    }
    Get.toNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: kOffWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HomeTileWidget(
            icon: Icons.add_box_rounded,
            text: 'Add Foods',
            onTap: () => _goOrRedirect(RouteName.AddFoodsScreen),
          ),
          HomeTileWidget(
            icon: Icons.restaurant_menu_rounded,
            text: 'Foods',
            onTap: () => _goOrRedirect(RouteName.FoodsList),
          ),
          HomeTileWidget(
            icon: Icons.storefront_rounded,
            text: 'Restaurant',
            onTap: () => Get.toNamed(RouteName.restaurantScreen),
          ),
        ],
      ),
    );
  }
}
