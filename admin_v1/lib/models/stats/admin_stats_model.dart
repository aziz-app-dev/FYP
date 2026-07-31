import 'dart:convert';

/// Dashboard stats as returned by GET /api/order/admin/stats.
AdminStatsModel adminStatsModelFromJson(String str) =>
    AdminStatsModel.fromJson(json.decode(str));

class AdminStatsModel {
  final int totalOrders;

  /// Order counts keyed by orderStatus ("Pending", "Delivered", ...).
  final Map<String, int> orders;
  final double revenueGrandTotal;
  final double revenueOrderTotal;
  final double revenueDeliveryFee;
  final int totalUsers;

  /// User counts keyed by userType ("Client", "Vendor", "Admin", "Driver").
  final Map<String, int> users;
  final int totalRestaurants;

  /// Restaurant counts keyed by verification ("Pending", "Verified", "Rejected").
  final Map<String, int> restaurants;

  AdminStatsModel({
    required this.totalOrders,
    required this.orders,
    required this.revenueGrandTotal,
    required this.revenueOrderTotal,
    required this.revenueDeliveryFee,
    required this.totalUsers,
    required this.users,
    required this.totalRestaurants,
    required this.restaurants,
  });

  static Map<String, int> _intMap(dynamic json) {
    if (json is! Map) return {};
    return json.map((k, v) => MapEntry(k.toString(), (v ?? 0) as int));
  }

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    final revenue = json["revenue"] ?? {};
    return AdminStatsModel(
      totalOrders: json["totalOrders"] ?? 0,
      orders: _intMap(json["orders"]),
      revenueGrandTotal: (revenue["grandTotal"] ?? 0).toDouble(),
      revenueOrderTotal: (revenue["orderTotal"] ?? 0).toDouble(),
      revenueDeliveryFee: (revenue["deliveryFee"] ?? 0).toDouble(),
      totalUsers: json["totalUsers"] ?? 0,
      users: _intMap(json["users"]),
      totalRestaurants: json["totalRestaurants"] ?? 0,
      restaurants: _intMap(json["restaurants"]),
    );
  }
}
