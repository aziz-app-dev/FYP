import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/components/status_chip.dart';
import '../../models/stats/admin_stats_model.dart';
import '../../view models/controllers/admin_stats_view_model.dart';

/// Platform-wide overview: order counts, revenue, users and
/// restaurant-verification breakdowns.
class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final AdminStatsController controller = Get.put(AdminStatsController());

  static final _money = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kPrimary,
      onRefresh: controller.fetchStats,
      child: Obx(() {
        final stats = controller.stats.value;
        if (controller.isLoading && stats == null) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }
        if (stats == null) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 120),
              Center(
                child: ReuseableText(
                  text: 'Could not load stats.\nPull down to retry.',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _summaryRow(stats),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Orders by status',
              child: _ordersBreakdown(stats),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Users',
              child: _countsWrap(stats.users, fallback: 'No users yet'),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Restaurants',
              child: _countsWrap(stats.restaurants,
                  fallback: 'No restaurants yet'),
            ),
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _summaryRow(AdminStatsModel stats) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.receipt_long_rounded,
            color: kPrimary,
            label: 'Total Orders',
            value: '${stats.totalOrders}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.payments_rounded,
            color: kSecondary,
            label: 'Revenue',
            value: _money.format(stats.revenueGrandTotal),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          ReuseableText(
            text: value,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            textColor: kDark,
          ),
          const SizedBox(height: 2),
          ReuseableText(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textColor: kGray,
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseableText(
            text: title,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textColor: kDark,
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _ordersBreakdown(AdminStatsModel stats) {
    const displayOrder = [
      'Pending',
      'Preparing',
      'Ready',
      'Out For Delivery',
      'Delivering',
      'Delivered',
      'Cancelled',
    ];
    final entries = [
      ...displayOrder.where((s) => stats.orders.containsKey(s)),
      ...stats.orders.keys.where((s) => !displayOrder.contains(s)),
    ];
    if (entries.isEmpty) {
      return const ReuseableText(
        text: 'No orders yet',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        textColor: kGray,
      );
    }
    return Column(
      children: entries.map((status) {
        final count = stats.orders[status] ?? 0;
        final total = stats.totalOrders == 0 ? 1 : stats.totalOrders;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              SizedBox(width: 130, child: StatusChip(label: status)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: count / total,
                    minHeight: 8,
                    backgroundColor: kOffWhite,
                    color: StatusChip.colorFor(status),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 32,
                child: ReuseableText(
                  text: '$count',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  textColor: kDark,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _countsWrap(Map<String, int> counts, {required String fallback}) {
    if (counts.isEmpty) {
      return ReuseableText(
        text: fallback,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        textColor: kGray,
      );
    }
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: counts.entries.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: kOffWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReuseableText(
                text: '${e.value}',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                textColor: kPrimary,
              ),
              const SizedBox(width: 6),
              ReuseableText(
                text: e.key,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
