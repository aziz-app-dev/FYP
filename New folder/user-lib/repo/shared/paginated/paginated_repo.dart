abstract class PaginatedRepo<T> {
  Future<PaginatedResult<T>> fetchItems({int page = 1, int limit = 10});
}

class PaginatedResult<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;

  PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasMore,
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<dynamic> data = json['items'] ?? json['data'] ?? [];
    return PaginatedResult(
      items: data.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: json['currentPage'] ?? json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? json['total'] ?? data.length,
      hasMore: json['hasMore'] ?? (json['currentPage'] ?? 1) < (json['totalPages'] ?? 1),
    );
  }
}
