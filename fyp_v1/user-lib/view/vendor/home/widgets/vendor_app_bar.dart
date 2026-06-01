import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/components/reuseable_text.dart';
import '../../../account_switcher/account_switcher_bottom_sheet.dart';

class VendorAppBar extends StatelessWidget {
  const VendorAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 100.h,
      padding: EdgeInsets.fromLTRB(12.w, 1.h, 12.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.spMin,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/1.jpg'),
              ),
              Padding(
                padding: EdgeInsets.all(8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReuseableText(
                      text: 'Kings Foods',
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: Colors.white,
                    ),
                    ReuseableText(
                      text: '187 LaFoods Street Union City, NJ 07087',
                      fontSize: 10.spMin,
                      fontWeight: FontWeight.normal,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Account switcher button
              GestureDetector(
                onTap: () {
                  AccountSwitcherBottomSheet.show(
                    onModeChanged: (mode) {
                      // Navigate based on mode
                      Get.offAllNamed('/customer/main');
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Image.asset(
                'assets/open.png',
                height: 30.spMin,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
