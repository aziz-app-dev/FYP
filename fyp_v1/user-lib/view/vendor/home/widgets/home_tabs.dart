import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../utils/utils.dart';
import 'tab_widget.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        height: 25.h,
        width: width,
        decoration: BoxDecoration(
          color: kOffWhite,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: List.generate(
            vendorOrderList.length,
            (i) {
              return TabWidget(
                text: vendorOrderList[i],
              );
            },
          ),
          labelColor: kLightWhite,
          padding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          unselectedLabelColor: kGray,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(25.r),
          ),
          labelPadding: EdgeInsets.zero,
          labelStyle: TextStyle(
            fontSize: 12.spMin,
            color: kLightWhite,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.spMin,
            color: kGray,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
