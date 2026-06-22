import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import '../../../bloc/driver/driver_cubit.dart';
import '../../../bloc/driver/driver_state.dart';
import '../../../config/config.dart';
import '../../../di/service_locator.dart';
import '../../../model/order/order_model.dart';
import '../../../routes/route_name.dart';
import '../../../services/session/session_manger.dart';
import '../../../services/socket/socket_service.dart';
import '../tasks/driver_qr_scan_page.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  late final DriverCubit _driverCubit;
  StreamSubscription<Map<String, dynamic>>? _driverSocketSub;

  @override
  void initState() {
    super.initState();
    _driverCubit = getIt<DriverCubit>()..bootstrap();
    _driverSocketSub = getIt<SocketService>().driverOrderAvailable.listen((_) {
      _driverCubit.bootstrap();
    });
  }

  @override
  void dispose() {
    _driverSocketSub?.cancel();
    _driverCubit.close();
    _index.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _driverCubit,
      child: BlocBuilder<DriverCubit, DriverState>(
        builder: (context, state) {
          final pages = [
            const _DriverHomeTab(),
            const _DriverDeliveriesTab(),
            const _DriverEarningsTab(),
            const _DriverProfileTab(),
          ];

          return ValueListenableBuilder<int>(
            valueListenable: _index,
            builder: (context, idx, _) => Scaffold(
              body: Stack(
                children: [
                  const _AnimatedDriverBackground(),
                  SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () => context.read<DriverCubit>().bootstrap(),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: pages[idx],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: idx,
                onDestinationSelected: (value) => _index.value = value,
                destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_shipping_outlined),
                  selectedIcon: Icon(Icons.local_shipping),
                  label: 'Deliveries',
                ),
                NavigationDestination(
                  icon: Icon(Icons.wallet_outlined),
                  selectedIcon: Icon(Icons.wallet),
                  label: 'Earnings',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DriverHomeTab extends StatelessWidget {
  const _DriverHomeTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final stats = state.stats;
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            Text(
              'Driver Hub',
              style: AppTextStyles.headlineMedium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Live deliveries and earnings synced with backend.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: 14.h),
            _StatusPanel(
              online: state.online,
              available: state.available,
              onOnlineChanged: (v) => context.read<DriverCubit>().toggleOnline(v),
              onAvailableChanged: (v) =>
                  context.read<DriverCubit>().toggleAvailable(v),
              onSyncLocation: () => context.read<DriverCubit>().syncLocation(),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Available',
                    value: '${state.availableOrders.length}',
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _MetricCard(
                    title: 'Active',
                    value: '${state.activeOrders.length}',
                    icon: Icons.motorcycle_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Rating',
                    value: (stats?.rating ?? 0).toStringAsFixed(1),
                    icon: Icons.star_rounded,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _MetricCard(
                    title: 'Earnings',
                    value: '\$${(stats?.totalEarnings ?? 0).toStringAsFixed(0)}',
                    icon: Icons.payments_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Text(
              'Top available orders',
              style: AppTextStyles.titleLarge.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            if (state.availableOrders.isEmpty)
              const _EmptyBox(message: 'No ready orders currently.')
            else
              ...state.availableOrders.take(2).map(
                    (order) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _OrderCard(order: order, isAvailable: true),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _DriverDeliveriesTab extends StatelessWidget {
  const _DriverDeliveriesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            Text(
              'Active deliveries',
              style: AppTextStyles.headlineMedium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            if (state.activeOrders.isEmpty)
              const _EmptyBox(message: 'No active deliveries.')
            else
              ...state.activeOrders.map((order) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _OrderCard(order: order, isAvailable: false),
                );
              }),
            SizedBox(height: 10.h),
            Text(
              'Available to accept',
              style: AppTextStyles.titleMedium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            if (state.availableOrders.isEmpty)
              const _EmptyBox(message: 'No unassigned ready orders.')
            else
              ...state.availableOrders.map((order) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _OrderCard(order: order, isAvailable: true),
                );
              }),
          ],
        );
      },
    );
  }
}

class _DriverEarningsTab extends StatelessWidget {
  const _DriverEarningsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final stats = state.stats;
        final deliveredCount = state.orderHistory
            .where((o) => o.orderStatus == OrderStatus.delivery)
            .length;
        final cancelledCount = state.orderHistory
            .where((o) => o.orderStatus == OrderStatus.cancelled)
            .length;
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            Text(
              'Earnings',
              style: AppTextStyles.headlineMedium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            _EarningsCard(
              label: 'Lifetime',
              value: '\$${(stats?.totalEarnings ?? 0).toStringAsFixed(0)}',
              percent: '${stats?.completedDeliveries ?? deliveredCount} deliveries',
            ),
            SizedBox(height: 10.h),
            _EarningsCard(
              label: 'Completion Rate',
              value: '${(stats?.completionRate ?? 0).toStringAsFixed(1)}%',
              percent: 'Cancelled: $cancelledCount',
            ),
            SizedBox(height: 10.h),
            _EarningsCard(
              label: 'History',
              value: '${state.orderHistory.length}',
              percent: 'Delivered: $deliveredCount',
            ),
          ],
        );
      },
    );
  }
}

class _DriverProfileTab extends StatelessWidget {
  const _DriverProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final profile = state.profile;
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            Text(
              'My Profile',
              style: AppTextStyles.headlineMedium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: context.colors.card.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.colors.primary.withValues(alpha: 0.12),
                  child: Icon(Icons.delivery_dining, color: context.colors.primary),
                ),
                title: Text(
                  profile?.name.isNotEmpty == true ? profile!.name : 'Driver',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '${profile?.vehicleType ?? 'bike'} ${profile?.vehicleNumber ?? ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              tileColor: context.colors.card.withValues(alpha: 0.92),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              leading: const Icon(Icons.reviews_outlined),
              title: const Text('View ratings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, RouteName.driverRatings),
            ),
            SizedBox(height: 8.h),
            ListTile(
              tileColor: context.colors.card.withValues(alpha: 0.92),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await SessionManager().clearSession();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.login,
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final bool online;
  final bool available;
  final ValueChanged<bool> onOnlineChanged;
  final ValueChanged<bool> onAvailableChanged;
  final VoidCallback onSyncLocation;

  const _StatusPanel({
    required this.online,
    required this.available,
    required this.onOnlineChanged,
    required this.onAvailableChanged,
    required this.onSyncLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E5BFF).withValues(alpha: 0.95),
            const Color(0xFF00A6FB).withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: online,
            onChanged: onOnlineChanged,
            contentPadding: EdgeInsets.zero,
            title: const Text('Go online', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              'Receive nearby delivery requests',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          SwitchListTile(
            value: available,
            onChanged: online ? onAvailableChanged : null,
            contentPadding: EdgeInsets.zero,
            title: const Text('Available', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              'Accept ready orders',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onSyncLocation,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2E5BFF),
              ),
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Sync location'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.colors.card.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.colors.primary),
          SizedBox(height: 10.h),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isAvailable;

  const _OrderCard({
    required this.order,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantName = order.restaurant?.title ?? 'Restaurant';
    final dropAddress = order.deliveryAddress?.fullAddress.isNotEmpty == true
        ? order.deliveryAddress!.fullAddress
        : 'Customer address';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.colors.card.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () =>
            Navigator.pushNamed(context, RouteName.driverTaskDetails, arguments: order),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.verificationCode ?? order.id,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Chip(label: Text(order.orderStatus.value)),
              ],
            ),
            Text(
              'Pickup: $restaurantName',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Drop: $dropAddress',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  '\$${order.deliveryFee.toStringAsFixed(0)} fee',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                const Spacer(),
                if (isAvailable)
                  FilledButton(
                    onPressed: () => context.read<DriverCubit>().acceptOrder(order.id),
                    child: const Text('Accept'),
                  )
                else
                  FilledButton(
                    onPressed: () => _scanAndComplete(context),
                    child: const Text('Complete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanAndComplete(BuildContext context) async {
    final scannedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const DriverQrScanPage()),
    );
    if (scannedCode == null || scannedCode.isEmpty || !context.mounted) return;

    await context.read<DriverCubit>().completeOrder(order.id, scannedCode);
    if (!context.mounted) return;

    final error = context.read<DriverCubit>().state.error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error == null
              ? 'Delivery completed successfully.'
              : 'Could not complete delivery: $error',
        ),
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String label;
  final String value;
  final String percent;

  const _EarningsCard({
    required this.label,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.colors.card.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  value,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Chip(
            avatar: const Icon(Icons.trending_up, size: 16),
            label: Text(percent),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String message;

  const _EmptyBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _AnimatedDriverBackground extends StatefulWidget {
  const _AnimatedDriverBackground();

  @override
  State<_AnimatedDriverBackground> createState() =>
      _AnimatedDriverBackgroundState();
}

class _AnimatedDriverBackgroundState extends State<_AnimatedDriverBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF5FAFF), Color(0xFFEAF3FF), Color(0xFFF8FCFF)],
                ),
              ),
            ),
            Positioned(
              top: -80 + (20 * t),
              left: -70,
              child: _BlurCircle(
                color: const Color(0xFF4B8BFF).withValues(alpha: 0.22),
                size: 200,
              ),
            ),
            Positioned(
              bottom: -90,
              right: -80 + (24 * t),
              child: _BlurCircle(
                color: const Color(0xFF00C6B7).withValues(alpha: 0.2),
                size: 230,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurCircle({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
