import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/colors/app_color.dart';
import '../../../utils/utils.dart';
import '../orders/tabs/cancelled_orders.dart';
import '../orders/tabs/delivered_orders.dart';
import '../orders/tabs/new_orders.dart';
import '../orders/tabs/pickup_orders.dart';
import '../orders/tabs/preparing_orders.dart';
import '../orders/tabs/ready_orders.dart';
import '../orders/tabs/self_delivery_orders.dart';
import 'widgets/home_tabs.dart';
import 'widgets/home_tiles.dart';
import 'widgets/vendor_app_bar.dart';

class VendorHomeView extends StatefulWidget {
  const VendorHomeView({super.key});

  @override
  State<VendorHomeView> createState() => _VendorHomeViewState();
}

class _VendorHomeViewState extends State<VendorHomeView>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: vendorOrderList.length, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondary,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: const VendorAppBar(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 15.h),
            const HomeTiles(),
            SizedBox(height: 15.h),
            HomeTabs(tabController: _tabController),
            SizedBox(height: 15.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: height * 0.7,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TabBarView(
                controller: _tabController,
                children: const [
                  NewOrders(),
                  PreparingOrders(),
                  ReadyOrders(),
                  PickupOrders(),
                  SelfDeliveryOrders(),
                  DeliveredOrders(),
                  CancelledOrders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
