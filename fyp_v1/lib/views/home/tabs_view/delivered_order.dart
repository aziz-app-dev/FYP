import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class DeliveredOrders extends StatelessWidget {
  const DeliveredOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderTabBase(status: OrderStatus.delivered);
  }
}
