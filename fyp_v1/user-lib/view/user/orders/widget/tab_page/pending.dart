import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../models/order/clint_orders_model.dart';
import '../../../../../repository/hooks/fetch_orders.dart';
import '../../../../../res/res_imports.dart';
import '../clint_order_tile.dart';

class Pending extends HookWidget {
  const Pending({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchOrders('Pending', 'Pending');
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
          final order = orders[i];
          return Column(
            children: order.orderItems
                .map((item) => ClintOrderTile(
                      food: item,
                      orderId: order.id,
                      refresh: refetch,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
