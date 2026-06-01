import 'package:flutter/material.dart';

import '../../../view models/controllers/vendor_order_view_model.dart';
import '_order_tab_base.dart';

class NewOrders extends StatelessWidget {
  const NewOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderTabBase(
      status: OrderStatus.pending,
      primaryLabel: 'Accept & Prepare',
      primaryNextStatus: OrderStatus.preparing,
      secondaryLabel: 'Cancel',
      secondaryNextStatus: OrderStatus.cancelled,
    );
  }
}
