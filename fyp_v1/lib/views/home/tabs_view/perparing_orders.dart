import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class PerparingOrders extends StatelessWidget {
  const PerparingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderTabBase(
      status: OrderStatus.preparing,
      primaryLabel: 'Mark Ready',
      primaryNextStatus: OrderStatus.ready,
      secondaryLabel: 'Cancel',
      secondaryNextStatus: OrderStatus.cancelled,
    );
  }
}
