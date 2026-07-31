import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/empty_state.dart';
import '../../view models/controllers/admin_order_view_model.dart';
import 'order_details_view.dart';
import 'widgets/order_card.dart';

/// All-platform orders, one tab per status (plus "All").
class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  static const List<(String label, String status)> _tabs = [
    ('All', OrderStatus.all),
    ('New', OrderStatus.pending),
    ('Preparing', OrderStatus.preparing),
    ('Ready', OrderStatus.ready),
    ('Picked Up', OrderStatus.pickedUp),
    ('Self-Delivery', OrderStatus.delivering),
    ('Delivered', OrderStatus.delivered),
    ('Cancelled', OrderStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        children: [
          Container(
            color: kWhite,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: kPrimary,
              unselectedLabelColor: kGray,
              indicatorColor: kPrimary,
              indicatorWeight: 3,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              tabs: [for (final t in _tabs) Tab(text: t.$1)],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final t in _tabs) _OrderTab(status: t.$2, label: t.$1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTab extends StatefulWidget {
  final String status;
  final String label;

  const _OrderTab({required this.status, required this.label});

  @override
  State<_OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<_OrderTab>
    with AutomaticKeepAliveClientMixin {
  late final AdminOrderController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Tag makes each tab its own controller instance (registry pattern).
    controller = Get.put(
      AdminOrderController(),
      tag: 'orders-${widget.status.isEmpty ? 'all' : widget.status}',
    );
    controller.fetchByStatus(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: kPrimary,
      onRefresh: () => controller.fetchByStatus(widget.status),
      child: Obx(() {
        if (controller.isLoading && controller.orders.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: kPrimary));
        }
        if (controller.orders.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 80),
              EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No ${widget.label} orders',
                message: 'Pull down to refresh.',
              ),
            ],
          );
        }
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return OrderCard(
              order: order,
              onTap: () => Get.to(
                () => OrderDetailsView(order: order, controller: controller),
              ),
            );
          },
        );
      }),
    );
  }
}
