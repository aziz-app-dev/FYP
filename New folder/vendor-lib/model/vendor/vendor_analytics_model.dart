class RevenueDataPoint {
  final String label;
  final double revenue;
  final int orderCount;

  const RevenueDataPoint({
    required this.label,
    required this.revenue,
    required this.orderCount,
  });

  factory RevenueDataPoint.fromJson(Map<String, dynamic> json) {
    return RevenueDataPoint(
      label: json['label']?.toString() ?? '',
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      orderCount: json['orderCount'] ?? 0,
    );
  }
}

class RevenueData {
  final String period;
  final List<RevenueDataPoint> data;

  const RevenueData({required this.period, required this.data});

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      period: json['period']?.toString() ?? 'daily',
      data: json['data'] == null
          ? []
          : (json['data'] as List)
              .map((e) => RevenueDataPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  double get totalRevenue => data.fold(0.0, (sum, d) => sum + d.revenue);
  int get totalOrders => data.fold(0, (sum, d) => sum + d.orderCount);
}

class TopSellingItem {
  final String? foodId;
  final String title;
  final String? imageUrl;
  final int totalQuantity;
  final double totalRevenue;

  const TopSellingItem({
    this.foodId,
    required this.title,
    this.imageUrl,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  factory TopSellingItem.fromJson(Map<String, dynamic> json) {
    return TopSellingItem(
      foodId: json['foodId']?.toString(),
      title: json['title']?.toString() ?? 'Unknown',
      imageUrl: json['imageUrl']?.toString(),
      totalQuantity: json['totalQuantity'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
    );
  }
}
