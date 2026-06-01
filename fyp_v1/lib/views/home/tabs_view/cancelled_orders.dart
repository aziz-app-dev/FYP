import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class CancelledOrders extends StatelessWidget {
  const CancelledOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // Undo = flip back to Pending. Shows up as a "Restore Order"
    // button on every cancelled tile AND on the details screen's
    // sticky action bar when the order is opened from here.
    return const OrderTabBase(
      status: OrderStatus.cancelled,
      primaryLabel: 'Restore Order',
      primaryNextStatus: OrderStatus.pending,
    );
  }
}
