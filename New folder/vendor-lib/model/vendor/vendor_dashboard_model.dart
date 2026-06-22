class VendorQuickStats {
  final int todayOrders;
  final int activeOrders;
  final int completedToday;
  final double todayRevenue;

  const VendorQuickStats({
    required this.todayOrders,
    required this.activeOrders,
    required this.completedToday,
    required this.todayRevenue,
  });

  factory VendorQuickStats.fromJson(Map<String, dynamic> json) {
    return VendorQuickStats(
      todayOrders: json['todayOrders'] ?? 0,
      activeOrders: json['activeOrders'] ?? 0,
      completedToday: json['completedToday'] ?? 0,
      todayRevenue: (json['todayRevenue'] as num?)?.toDouble() ?? 0,
    );
  }
}

class VendorDashboardSummary {
  final int totalOrders;
  final int activeOrders;
  final double todayRevenue;
  final double monthlyRevenue;
  final int monthlyOrderCount;
  final double avgOrderValue;
  final double rating;
  final bool isAvailable;

  const VendorDashboardSummary({
    required this.totalOrders,
    required this.activeOrders,
    required this.todayRevenue,
    required this.monthlyRevenue,
    required this.monthlyOrderCount,
    required this.avgOrderValue,
    required this.rating,
    required this.isAvailable,
  });

  factory VendorDashboardSummary.fromJson(Map<String, dynamic> json) {
    return VendorDashboardSummary(
      totalOrders: json['totalOrders'] ?? 0,
      activeOrders: json['activeOrders'] ?? 0,
      todayRevenue: (json['todayRevenue'] as num?)?.toDouble() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0,
      monthlyOrderCount: json['monthlyOrderCount'] ?? 0,
      avgOrderValue: (json['avgOrderValue'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}
