import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_order/vendor_order_bloc.dart';
import '../../../bloc/vendor/vendor_order/vendor_order_event.dart';
import '../../../bloc/vendor/vendor_order/vendor_order_state.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../di/service_locator.dart';
import '../../../model/vendor/vendor_order_model.dart';
import '../../../routes/route_name.dart';
import '../../../services/socket/socket_service.dart';
import '../../../utils/toast_utils.dart';

class VendorOrdersPage extends StatelessWidget {
  const VendorOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorOrderBloc>(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatefulWidget {
  const _OrdersView();

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SocketService _socketService = SocketService();
  StreamSubscription<Map<String, dynamic>>? _restaurantRequestSub;
  StreamSubscription<Map<String, dynamic>>? _restaurantUpdateSub;
  String? _joinedRestaurantId;
  final _tabs = const ['All', 'Pending', 'Placed', 'Preparing', 'Ready', 'Completed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _restaurantRequestSub = _socketService.restaurantOrderRequests.listen(_onRestaurantSocketEvent);
    _restaurantUpdateSub = _socketService.restaurantOrderUpdates.listen(_onRestaurantSocketEvent);
    _loadOrders(null);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final status = _tabController.index == 0 ? null : _tabs[_tabController.index];
    final mapped = _mapStatus(status);
    _loadOrders(mapped);
  }

  String? _mapStatus(String? tab) {
    if (tab == null || tab == 'All') return null;
    if (tab == 'Completed') return 'Delivery';
    return tab;
  }

  void _loadOrders(String? status) {
    final restState = context.read<VendorRestaurantBloc>().state;
    final restaurantId = restState.activeRestaurant?.id;
    if (restaurantId == null) return;

    if (_joinedRestaurantId != restaurantId) {
      if (_joinedRestaurantId != null) {
        _socketService.leaveRestaurantRoom(_joinedRestaurantId!);
      }
      _socketService.joinRestaurantRoom(restaurantId);
      _joinedRestaurantId = restaurantId;
    }

    context.read<VendorOrderBloc>().add(
          LoadVendorOrders(restaurantId: restaurantId, statusFilter: status),
        );
  }

  void _onRestaurantSocketEvent(Map<String, dynamic> data) {
    final eventRestaurantId = data['restaurantId']?.toString();
    if (eventRestaurantId == null || _joinedRestaurantId == null) return;
    if (eventRestaurantId != _joinedRestaurantId) return;

    final status = _tabController.index == 0 ? null : _tabs[_tabController.index];
    final mapped = _mapStatus(status);
    _loadOrders(mapped);
  }

  @override
  void dispose() {
    _restaurantRequestSub?.cancel();
    _restaurantUpdateSub?.cancel();
    if (_joinedRestaurantId != null) {
      _socketService.leaveRestaurantRoom(_joinedRestaurantId!);
    }
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan Order QR',
            onPressed: () => Navigator.pushNamed(
              context,
              RouteName.qrScanner,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: BlocConsumer<VendorOrderBloc, VendorOrderState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ToastUtils.showSuccess(context, message: state.successMessage!);
          }
          if (state.hasError) {
            ToastUtils.showError(context, message: state.errorMessage ?? 'Error');
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12.spMin),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return _OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final VendorOrder order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.spMin),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          RouteName.vendorOrderDetails,
          arguments: order.id,
        ),
        child: Padding(
          padding: EdgeInsets.all(14.spMin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.id.substring(order.id.length - 6)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.spMin,
                    ),
                  ),
                  _StatusChip(status: order.orderStatus),
                ],
              ),
              SizedBox(height: 6.spMin),
              if (order.customer != null)
                Text(
                  order.customer!.username ?? order.customer!.email ?? 'Customer',
                  style: TextStyle(fontSize: 13.spMin),
                ),
              SizedBox(height: 4.spMin),
              Text(
                '${order.items.length} items - ${formatPrice(order.grandTotal)}',
                style: TextStyle(
                  fontSize: 13.spMin,
                  color: Colors.grey[600],
                ),
              ),
              if (order.createdAt != null) ...[
                SizedBox(height: 4.spMin),
                Text(
                  _formatTime(order.createdAt!),
                  style: TextStyle(fontSize: 11.spMin, color: Colors.grey),
                ),
              ],
              if (order.nextStatuses.isNotEmpty) ...[
                SizedBox(height: 10.spMin),
                Wrap(
                  spacing: 8.spMin,
                  children: order.nextStatuses.map((s) {
                    final isCancel = s == 'Cancelled';
                    return ElevatedButton(
                      onPressed: () {
                        context.read<VendorOrderBloc>().add(
                              UpdateVendorOrderStatus(
                                orderId: order.id,
                                newStatus: s,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCancel ? Colors.red : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.spMin,
                          vertical: 6.spMin,
                        ),
                      ),
                      child: Text(
                        isCancel ? 'Cancel' : s,
                        style: TextStyle(fontSize: 12.spMin),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Placed':
        color = Colors.blue;
        break;
      case 'Preparing':
        color = Colors.purple;
        break;
      case 'Ready':
        color = Colors.teal;
        break;
      case 'Out For Delivery':
        color = Colors.indigo;
        break;
      case 'Delivery':
        color = Colors.green;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.spMin, vertical: 4.spMin),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        status == 'Delivery' ? 'Completed' : status,
        style: TextStyle(color: color, fontSize: 11.spMin, fontWeight: FontWeight.w600),
      ),
    );
  }
}
