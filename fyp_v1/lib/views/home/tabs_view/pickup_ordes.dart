import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class PickupOrders extends StatelessWidget {
  const PickupOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // Orders currently with a delivery driver.
    return const OrderTabBase(
      status: OrderStatus.pickedUp,
      primaryLabel: 'Mark Delivered',
      primaryNextStatus: OrderStatus.delivered,
    );
  }
}
