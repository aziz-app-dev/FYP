import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import '../../../bloc/user/order/order_bloc.dart';
import '../../../bloc/user/order/order_event.dart';
import '../../../bloc/user/order/order_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../const/app_url.dart';
import '../../../di/service_locator.dart';
import '../../../model/order/order_model.dart';
import '../../../routes/route_name.dart';
import '../../../utils/loaders_utils.dart';
import 'widgets/tracking_map_widget.dart';
import 'widgets/tracking_bottom_sheet.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel? order;

  const OrderTrackingScreen({super.key, this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late OrderBloc _orderBloc;
  final MapController _mapController = MapController();
  Timer? _refreshTimer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _orderBloc = getIt<OrderBloc>();

    if (widget.order != null) {
      _orderBloc.add(LoadOrderByIdEvent(widget.order!.id));
    } else {
      _orderBloc.add(const LoadActiveOrdersEvent());
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final state = _orderBloc.state;
      final order = state.selectedOrder ?? state.currentTrackingOrder;
      if (order != null && order.isBeingDelivered) {
        _orderBloc.add(LoadOrderByIdEvent(order.id));
      }
    });
  }

  @override
  void dispose() {
    _orderBloc.close();
    _refreshTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _orderBloc,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final isLoading = state.status == OrderLoadingStatus.loading &&
                state.selectedOrder == null &&
                state.activeOrders.isEmpty;

            final order = state.selectedOrder ?? state.currentTrackingOrder;
            final hasOrder = order != null;

            return Stack(
              children: [
                // Map background — always visible
                if (hasOrder)
                  TrackingMapWidget(
                    order: order,
                    mapController: _mapController,
                    pulseController: _pulseController,
                  )
                else
                  _buildDefaultMap(),

                // Header — always on top
                SafeArea(
                  bottom: false,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h),
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(color: colors.shadow, blurRadius: 10),
                      ],
                    ),
                    child: CustomHeader(
                      title: 'Track Order',
                      action: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasOrder && _buildEstimatedTime(order) != null)
                            _buildEstimatedTime(order)!,
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.qrScanner,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(6.spMin),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                size: 20.spMin,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalPadding: HeaderVerticalPadding.none,
                    ),
                  ),
                ),

                // Loading
                if (isLoading) Center(child: appLoader()),

                // Empty
                if (!isLoading && !hasOrder) _buildEmptyState(colors),

                // Bottom sheet
                if (hasOrder)
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(),
                        TrackingBottomSheet(
                          order: order,
                          currentStep: order.orderStatus.stepIndex,
                          onCancel: () => _showCancelDialog(order),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDefaultMap() {
    final colors = context.colors;
    final token = AppUrl.mapboxAccessToken;
    final hasMapbox = token != 'YOUR_MAPBOX_ACCESS_TOKEN' && token.isNotEmpty;
    final mapStyle = colors.isDark ? 'mapbox/dark-v11' : 'mapbox/streets-v12';
    final tileUrl = hasMapbox
        ? 'https://api.mapbox.com/styles/v1/$mapStyle/tiles/{z}/{x}/{y}@2x?access_token=$token'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    return Positioned.fill(
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(31.5204, 74.3587),
          initialZoom: 12.0,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: tileUrl,
            userAgentPackageName: 'com.example.food',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeColors colors) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delivery_dining_rounded,
                size: 50.spMin,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No Active Orders',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your active orders will appear here\nfor real-time tracking',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () =>
                  _orderBloc.add(const LoadActiveOrdersEvent()),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildEstimatedTime(OrderModel order) {
    final estimatedTime = _getEstimatedTime(order);
    if (estimatedTime == '--') return null;

    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14.spMin,
            color: colors.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            estimatedTime,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getEstimatedTime(OrderModel order) {
    if (order.estimatedDeliveryTime != null) {
      final diff = order.estimatedDeliveryTime!.difference(DateTime.now());
      if (diff.inMinutes > 0) {
        return '${diff.inMinutes} min';
      }
    }
    switch (order.orderStatus) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return '30-45 min';
      case OrderStatus.preparing:
        return '20-30 min';
      case OrderStatus.ready:
        return '15-20 min';
      case OrderStatus.outForDelivery:
        return '10-15 min';
      case OrderStatus.delivery:
        return 'Delivered';
      default:
        return '--';
    }
  }

  void _showCancelDialog(OrderModel order) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Cancel Order?',
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No, Keep Order',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _orderBloc.add(CancelOrderEvent(order.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
