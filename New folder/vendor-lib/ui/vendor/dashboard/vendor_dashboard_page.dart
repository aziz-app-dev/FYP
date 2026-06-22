import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_dashboard/vendor_dashboard_bloc.dart';
import '../../../bloc/vendor/vendor_dashboard/vendor_dashboard_event.dart';
import '../../../bloc/vendor/vendor_dashboard/vendor_dashboard_state.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../di/service_locator.dart';
import '../../../routes/route_name.dart';

class VendorDashboardPage extends StatelessWidget {
  const VendorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorDashboardBloc>(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorRestaurantBloc, VendorRestaurantState>(
      builder: (context, restState) {
        final restaurant = restState.activeRestaurant;
        if (restaurant == null) {
          return const Center(child: Text('No restaurant selected'));
        }

        // Trigger dashboard load
        final dashBloc = context.read<VendorDashboardBloc>();
        if (dashBloc.state.status == VendorDashboardStatus.initial) {
          dashBloc.add(LoadDashboard(restaurantId: restaurant.id!));
        }

        return BlocBuilder<VendorDashboardBloc, VendorDashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<VendorDashboardBloc>().add(
                      RefreshDashboard(restaurantId: restaurant.id!),
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.spMin,
                          backgroundImage: restaurant.logoUrl != null
                              ? NetworkImage(restaurant.logoUrl!)
                              : null,
                          child: restaurant.logoUrl == null
                              ? Icon(Icons.restaurant, size: 24.spMin)
                              : null,
                        ),
                        SizedBox(width: 12.spMin),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant.title ?? 'My Restaurant',
                                style: TextStyle(
                                  fontSize: 18.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8.spMin,
                                    height: 8.spMin,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: restaurant.isAvailable == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 4.spMin),
                                  Text(
                                    restaurant.isAvailable == true
                                        ? 'Open'
                                        : 'Closed',
                                    style: TextStyle(fontSize: 12.spMin),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.spMin),

                    // Stats cards
                    if (state.isLoading && state.summary == null)
                      const Center(child: CircularProgressIndicator())
                    else if (state.summary != null) ...[
                      _buildStatsGrid(context, state),
                      SizedBox(height: 20.spMin),
                    ],

                    // Quick actions
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.spMin),
                    _buildQuickActions(context),

                    SizedBox(height: 20.spMin),

                    // Recent orders
                    if (state.recentOrders.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pending Orders',
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              RouteName.vendorOrders,
                            ),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      ...state.recentOrders.take(3).map(
                            (order) => Card(
                              margin: EdgeInsets.only(bottom: 8.spMin),
                              child: ListTile(
                                title: Text(
                                  '#${order.id.substring(order.id.length - 6)}',
                                ),
                                subtitle: Text(
                                  '${order.items.length} items - ${formatPrice(order.grandTotal)}',
                                ),
                                trailing: Chip(
                                  label: Text(
                                    order.orderStatus,
                                    style: TextStyle(fontSize: 11.spMin),
                                  ),
                                ),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  RouteName.vendorOrderDetails,
                                  arguments: order.id,
                                ),
                              ),
                            ),
                          ),
                    ],

                    // Top items
                    if (state.topItems.isNotEmpty) ...[
                      SizedBox(height: 16.spMin),
                      Text(
                        'Top Selling Items',
                        style: TextStyle(
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.spMin),
                      ...state.topItems.take(5).map(
                            (item) => ListTile(
                              leading: item.imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.imageUrl!,
                                        width: 48.spMin,
                                        height: 48.spMin,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.fastfood, size: 40.spMin),
                              title: Text(item.title),
                              subtitle: Text(
                                '${item.totalQuantity} sold',
                              ),
                              trailing: Text(
                                formatPrice(item.totalRevenue),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.primary,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context, VendorDashboardState state) {
    final summary = state.summary!;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.spMin,
      crossAxisSpacing: 10.spMin,
      childAspectRatio: 1.6,
      children: [
        _StatCard(
          title: 'Today Revenue',
          value: formatPrice(summary.todayRevenue),
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Active Orders',
          value: '${summary.activeOrders}',
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Monthly Revenue',
          value: formatPrice(summary.monthlyRevenue),
          icon: Icons.trending_up,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Rating',
          value: summary.rating.toStringAsFixed(1),
          icon: Icons.star,
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _QuickAction(
          icon: Icons.receipt_long,
          label: 'Orders',
          onTap: () =>
              Navigator.pushNamed(context, RouteName.vendorOrders),
        ),
        SizedBox(width: 12.spMin),
        _QuickAction(
          icon: Icons.restaurant_menu,
          label: 'Menu',
          onTap: () =>
              Navigator.pushNamed(context, RouteName.vendorMenu),
        ),
        SizedBox(width: 12.spMin),
        _QuickAction(
          icon: Icons.analytics,
          label: 'Analytics',
          onTap: () =>
              Navigator.pushNamed(context, RouteName.vendorAnalytics),
        ),
        SizedBox(width: 12.spMin),
        _QuickAction(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () =>
              Navigator.pushNamed(context, RouteName.vendorSettings),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.spMin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22.spMin),
            SizedBox(height: 6.spMin),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.spMin,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.spMin,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.spMin),
            child: Column(
              children: [
                Icon(icon, size: 28.spMin, color: context.colors.primary),
                SizedBox(height: 4.spMin),
                Text(label, style: TextStyle(fontSize: 11.spMin)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
