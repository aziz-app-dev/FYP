import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/colors/app_color.dart';
import '../../../utils/utils.dart';
import 'tab_widget.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: TabBar(
          controller: _tabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: kGrayLight,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            color: kPrimary,
          ),
          labelStyle: TextStyle(
              fontSize: 13.spMin,
              color: kLightWhite,
              fontWeight: FontWeight.normal),
          tabs: List.generate(
              orderList.length, (index) => TabWidget(text: orderList[index]))),
    );
  }
}
