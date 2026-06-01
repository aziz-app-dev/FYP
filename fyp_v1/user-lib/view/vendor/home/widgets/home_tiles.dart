import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../navigation/route_names.dart';
import 'home_tile_widget.dart';

class HomeTiles extends StatelessWidget {
  const HomeTiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      height: 65.h,
      decoration: BoxDecoration(
        color: kOffWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeTileWidget(
              onTap: () {
                Get.toNamed(RouteNames.vendorAddFood);
              },
              iconPath: 'assets/dish.png',
              text: 'Add Foods',
            ),
            HomeTileWidget(
              onTap: () {},
              iconPath: 'assets/money.png',
              text: 'Wallet',
            ),
            HomeTileWidget(
              onTap: () {
                Get.toNamed(RouteNames.vendorFoodsList);
              },
              iconPath: 'assets/fast-food.png',
              text: 'Foods',
            ),
            HomeTileWidget(
              onTap: () {},
              iconPath: 'assets/delivery-truck.png',
              text: 'Delivery',
            ),
          ],
        ),
      ),
    );
  }
}
