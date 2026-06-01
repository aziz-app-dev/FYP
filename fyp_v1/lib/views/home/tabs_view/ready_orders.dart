import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class ReadyOrders extends StatelessWidget {
  const ReadyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // From "Ready" the vendor chooses the delivery path:
    //   - Hand the order to a driver        -> goes to "Picked Up"
    //   - Deliver with their own staff      -> goes to "Self-Deliveries"
    return const OrderTabBase(
      status: OrderStatus.ready,
      primaryLabel: 'Hand to Driver',
      primaryNextStatus: OrderStatus.pickedUp,
      secondaryLabel: 'Self-Deliver',
      secondaryNextStatus: OrderStatus.delivering,
    );
  }
}
