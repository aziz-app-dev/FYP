import '../../../data/api/api_reospes.dart';

class PaginatedState<T> {
  final ApiResponse<List<T>> items;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  PaginatedState({
    required this.items,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  factory PaginatedState.initial() {
    return PaginatedState(items: ApiResponse.initial());
  }

  PaginatedState<T> copyWith({
    ApiResponse<List<T>>? items,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaginatedState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
