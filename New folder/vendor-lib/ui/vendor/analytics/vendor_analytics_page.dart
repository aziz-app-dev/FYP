import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_analytics/vendor_analytics_bloc.dart';
import '../../../bloc/vendor/vendor_analytics/vendor_analytics_event.dart';
import '../../../bloc/vendor/vendor_analytics/vendor_analytics_state.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../config/config.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../di/service_locator.dart';

class VendorAnalyticsPage extends StatelessWidget {
  const VendorAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorAnalyticsBloc>(),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatefulWidget {
  const _AnalyticsView();

  @override
  State<_AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<_AnalyticsView> {
  @override
  void initState() {
    super.initState();
    _load('daily');
  }

  void _load(String period) {
    final restState = context.read<VendorRestaurantBloc>().state;
    final id = restState.activeRestaurant?.id;
    if (id != null) {
      context.read<VendorAnalyticsBloc>().add(
            LoadAnalytics(restaurantId: id, period: period),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: BlocBuilder<VendorAnalyticsBloc, VendorAnalyticsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.spMin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period selector
                Row(
                  children: ['daily', 'weekly', 'monthly'].map((p) {
                    final selected = state.selectedPeriod == p;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.spMin),
                      child: ChoiceChip(
                        label: Text(p[0].toUpperCase() + p.substring(1)),
                        selected: selected,
                        onSelected: (_) {
                          final id = context
                              .read<VendorRestaurantBloc>()
                              .state
                              .activeRestaurant
                              ?.id;
                          if (id != null) {
                            context.read<VendorAnalyticsBloc>().add(
                                  ChangePeriod(restaurantId: id, period: p),
                                );
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20.spMin),

                // Revenue summary
                if (state.isLoading && state.revenueData == null)
                  const Center(child: CircularProgressIndicator())
                else if (state.revenueData != null) ...[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.spMin),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatPrice(state.revenueData!.totalRevenue),
                                  style: TextStyle(
                                    fontSize: 22.spMin,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.primary,
                                  ),
                                ),
                                Text('Total Revenue',
                                    style: TextStyle(fontSize: 12.spMin, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${state.revenueData!.totalOrders}',
                                  style: TextStyle(
                                    fontSize: 22.spMin,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Total Orders',
                                    style: TextStyle(fontSize: 12.spMin, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.spMin),

                  // Revenue bars
                  Text(
                    'Revenue Breakdown',
                    style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.spMin),
                  ...state.revenueData!.data.map(
                    (d) {
                      final maxRevenue = state.revenueData!.data
                          .fold<double>(0.0, (m, e) => e.revenue > m ? e.revenue : m);
                      final ratio = maxRevenue > 0 ? d.revenue / maxRevenue : 0.0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.spMin),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80.spMin,
                              child: Text(
                                d.label,
                                style: TextStyle(fontSize: 11.spMin),
                              ),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 16.spMin,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(width: 8.spMin),
                            SizedBox(
                              width: 70.spMin,
                              child: Text(
                                formatPrice(d.revenue),
                                style: TextStyle(fontSize: 11.spMin),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],

                // Top items
                if (state.topItems.isNotEmpty) ...[
                  SizedBox(height: 24.spMin),
                  Text(
                    'Top Selling Items',
                    style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.spMin),
                  ...state.topItems.asMap().entries.map(
                        (entry) => ListTile(
                          leading: CircleAvatar(
                            child: Text('${entry.key + 1}'),
                          ),
                          title: Text(entry.value.title),
                          subtitle: Text('${entry.value.totalQuantity} sold'),
                          trailing: Text(
                            formatPrice(entry.value.totalRevenue),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                ],

                if (state.hasError)
                  Padding(
                    padding: EdgeInsets.all(16.spMin),
                    child: Text(
                      state.errorMessage ?? 'Error loading analytics',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
