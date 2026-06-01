import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class SelfDeliveryOrders extends StatelessWidget {
  const SelfDeliveryOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // Orders the vendor is delivering themselves.
    return const OrderTabBase(
      status: OrderStatus.delivering,
      primaryLabel: 'Mark Delivered',
      primaryNextStatus: OrderStatus.delivered,
    );
  }
}
