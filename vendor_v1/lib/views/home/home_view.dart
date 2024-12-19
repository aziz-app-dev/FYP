import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/res/colors/app_color.dart';
import '../../common/res/components/coustom_appBar.dart';
import '../../common/utils/utils.dart';
import 'tabs_view/cancelled_orders.dart';
import 'tabs_view/delivered_order.dart';
import 'tabs_view/new_orders.dart';
import 'tabs_view/perparing_orders.dart';
import 'tabs_view/pickup_ordes.dart';
import 'tabs_view/ready_orders.dart';
import 'tabs_view/self_delivery_orders.dart';
import 'widgets/home_tabs.dart';
import 'widgets/home_tiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: orderList.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondary,
        elevation: 0,
        flexibleSpace: const CustomAppbar(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 15.h,
            ),
            const HomeTiles(),
            SizedBox(
              height: 15.h,
            ),
            HomeTabs(tabController: _tabController),
            SizedBox(
              height: 15.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: height * 0.7,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TabBarView(controller: _tabController, children: const [
                NewOrders(),
                PerparingOrders(),
                ReadyOrders(),
                PickupOrders(),
                SelfDeliveryOrders(),
                DeliveredOrders(),
                CancelledOrders(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
