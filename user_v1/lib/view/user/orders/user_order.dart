import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../utils/utils.dart';
import 'widget/order_tab_widget.dart';
import 'widget/tab_page/cencelled.dart';
import 'widget/tab_page/delivered.dart';
import 'widget/tab_page/delivering.dart';
import 'widget/tab_page/pending.dart';
import 'widget/tab_page/perparing.dart';

class UserOrderScreen extends StatefulWidget {
  const UserOrderScreen({super.key});

  @override
  State<UserOrderScreen> createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: orderList.length, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        centerTitle: true,
        title: const ReuseableText(
          text: 'My Order',
          fontSize: 16,
          textColor: kPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: height,
          // width: width,
          color: kWhite,
          child: Column(
            children: [
              SizedBox(
                height: 18.h,
              ),
              OrderTab(tabController: _tabController),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: height,
                width: width,
                child: TabBarView(controller: _tabController, children: const [
                  Pending(),
                  Preparing(),
                  Delivering(),
                  Delivered(),
                  Cancelled(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
