import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../models/order/clint_orders_model.dart';
import '../../../../../repository/hooks/fetch_orders.dart';
import '../clint_order_tile.dart';
import '../../../../../res/res_imports.dart';

class Preparing extends HookWidget {
  const Preparing({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchOrders('Preparing', 'Pending');
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    List<ClientOrderModel> orders = hookResult.data;
    // print('Pending orders: ----${orders}');
    if (isLoading) {
      return const FoodListShimmer();
    }
    if (orders.isEmpty) {
      return const Center(child: Text("No orders found"));
    }
    return SizedBox(
      height: height,
      width: width,
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, i) {
          String orderId = orders[i].id;
          return ClintOrderTile(
            food: orders[i].orderItems[0],
            orderId: orderId,
            refresh: refetch,
          );
        },
      ),
    );
  }
}
