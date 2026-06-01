import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/order/vendor_order_model.dart';
import 'vendor_order_view_model.dart';

/// One entry in the "top sellers" list: a food aggregated across all
/// delivered orders.
class TopSeller {
  final String foodId;
  final String title;
  final String imageUrl;
  final int qty;
  final double revenue;

  TopSeller({
    required this.foodId,
    required this.title,
    required this.imageUrl,
    required this.qty,
    required this.revenue,
  });
}

/// Aggregates vendor-side order data into the dashboard KPIs shown on
/// the restaurant page when the restaurant is Verified.
///
/// Everything is computed client-side from the existing
/// `GET /api/order/vendor` endpoint — no new backend work needed.
class VendorAnalyticsController extends GetxController {
  final box = GetStorage();

  final RxBool _loading = false.obs;
  bool get isLoading => _loading.value;

  // KPIs
  final RxDouble totalRevenue = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt todayOrders = 0.obs;
  final RxInt pendingOrders = 0.obs;
  final RxInt deliveredOrders = 0.obs;
  final RxInt cancelledOrders = 0.obs;
  final RxDouble avgOrderValue = 0.0.obs;

  /// Revenue for the last 7 calendar days, oldest-first. Length is 7.
  final RxList<double> last7DaysRevenue = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final RxList<String> last7DayLabels =
      <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].obs;

  /// The 5 best-selling foods by quantity across delivered orders.
  final RxList<TopSeller> topSellers = <TopSeller>[].obs;

  /// The 10 most recent cancelled orders (for the Cancelled Orders panel).
  final RxList<VendorOrder> recentCancelled = <VendorOrder>[].obs;

  Future<void> fetch() async {
    _loading.value = true;
    try {
      final token = box.read('token');
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/order/vendor'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body) as List;
        final orders =
            list.map((e) => VendorOrder.fromJson(e)).toList(growable: false);
        _aggregate(orders);
      }
    } catch (_) {
      // Analytics are non-critical — fail quietly.
    } finally {
      _loading.value = false;
    }
  }

  void _aggregate(List<VendorOrder> orders) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // 7-day buckets: oldest -> today.
    final List<DateTime> dayStarts = List.generate(7, (i) {
      final d = todayStart.subtract(Duration(days: 6 - i));
      return DateTime(d.year, d.month, d.day);
    });
    final buckets = List<double>.filled(7, 0);
    const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final labels = dayStarts.map((d) => weekdayNames[d.weekday - 1]).toList();

    double revenue = 0;
    int today = 0;
    int pending = 0;
    int delivered = 0;
    int cancelled = 0;

    // Accumulate per-food totals (delivered orders only).
    final Map<String, TopSeller> byFood = {};
    final List<VendorOrder> cancelledList = [];

    for (final o in orders) {
      final isDelivered = o.orderStatus == 'Delivered';
      final isCancelled = o.orderStatus == 'Cancelled';
      if (isDelivered) revenue += o.grandTotal;
      if (isCancelled) {
        cancelled++;
        cancelledList.add(o);
      }

      final created = o.createdAt;
      if (created != null) {
        final createdDay = DateTime(created.year, created.month, created.day);
        if (createdDay == todayStart) today++;

        if (isDelivered) {
          final idx = dayStarts.indexWhere((d) => d == createdDay);
          if (idx >= 0) buckets[idx] += o.grandTotal;
        }
      }

      if (o.orderStatus == 'Pending' || o.orderStatus == 'Preparing') {
        pending++;
      }
      if (isDelivered) {
        delivered++;

        // Tally top sellers
        for (final item in o.orderItems) {
          final key = item.foodId;
          final existing = byFood[key];
          if (existing == null) {
            byFood[key] = TopSeller(
              foodId: item.foodId,
              title: item.foodTitle,
              imageUrl:
                  item.foodImageUrl.isNotEmpty ? item.foodImageUrl.first : '',
              qty: item.quantity,
              revenue: item.price,
            );
          } else {
            byFood[key] = TopSeller(
              foodId: existing.foodId,
              title: existing.title,
              imageUrl: existing.imageUrl,
              qty: existing.qty + item.quantity,
              revenue: existing.revenue + item.price,
            );
          }
        }
      }
    }

    // Sort cancelled list newest first, keep 10.
    cancelledList.sort((a, b) =>
        (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000)));
    recentCancelled.assignAll(cancelledList.take(10));

    // Sort top sellers by qty desc, keep 5.
    final sorted = byFood.values.toList()
      ..sort((a, b) => b.qty.compareTo(a.qty));
    topSellers.assignAll(sorted.take(5));

    totalRevenue.value = revenue;
    totalOrders.value = orders.length;
    todayOrders.value = today;
    pendingOrders.value = pending;
    deliveredOrders.value = delivered;
    cancelledOrders.value = cancelled;
    avgOrderValue.value = delivered == 0 ? 0 : revenue / delivered;
    last7DaysRevenue.assignAll(buckets);
    last7DayLabels.assignAll(labels);
  }

  /// Restore a cancelled order by flipping it back to "Pending".
  /// Refetches analytics AND asks every open home-tab controller to
  /// refetch so the undone order appears in New Orders immediately.
  Future<void> undoCancel(String orderId) async {
    try {
      final token = box.read('token');
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/api/order/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'orderStatus': 'Pending'}),
      );

      if (response.statusCode == 200) {
        // Optimistic: drop the order from our local cancelled list
        // so the UI updates instantly. Then refetch everything to be
        // sure the aggregates are correct.
        recentCancelled.removeWhere((o) => o.id == orderId);
        cancelledOrders.value =
            (cancelledOrders.value - 1).clamp(0, 1 << 30);

        Utils.showSuccess(
          'Order restored',
          'Moved back to New Orders.',
        );

        // Re-aggregate from the server for correctness.
        await fetch();

        // Broadcast to the home-tab registry so New Orders / Cancelled
        // tabs show the fresh data without needing a manual pull.
        for (final ctrl in VendorOrderController.allRegistered) {
          // ignore: unawaited_futures
          ctrl.refetch();
        }
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Could not restore', err.message);
      }
    } catch (e) {
      Utils.showError('Error', e.toString());
    }
  }
}
