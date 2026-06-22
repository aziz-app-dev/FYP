import 'package:equatable/equatable.dart';

import '../../../data/api/api_reospes.dart';
import '../../../model/home/home_model.dart';

class SearchFilters extends Equatable {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String? sortBy; // 'price_low', 'price_high', 'rating', 'name'
  final List<String> foodTypes;

  const SearchFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sortBy,
    this.foodTypes = const [],
  });

  bool get hasActiveFilters =>
      category != null ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      sortBy != null ||
      foodTypes.isNotEmpty;

  int get activeFilterCount {
    int count = 0;
    if (category != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    if (sortBy != null) count++;
    if (foodTypes.isNotEmpty) count++;
    return count;
  }

  /// Returns a map of active filter labels for displaying as chips.
  Map<String, String> get activeFilterLabels {
    final labels = <String, String>{};
    if (category != null) labels['category'] = category!;
    if (minPrice != null && maxPrice != null) {
      labels['price'] = '\$${minPrice!.toInt()} - \$${maxPrice!.toInt()}';
    } else if (minPrice != null) {
      labels['price'] = 'Min \$${minPrice!.toInt()}';
    } else if (maxPrice != null) {
      labels['price'] = 'Max \$${maxPrice!.toInt()}';
    }
    if (minRating != null) labels['rating'] = '${minRating!}+ Stars';
    if (sortBy != null) {
      final sortLabels = {
        'price_low': 'Price: Low to High',
        'price_high': 'Price: High to Low',
        'rating': 'Highest Rated',
        'name': 'Name A-Z',
      };
      labels['sortBy'] = sortLabels[sortBy] ?? sortBy!;
    }
    if (foodTypes.isNotEmpty) {
      labels['foodTypes'] = foodTypes.join(', ');
    }
    return labels;
  }

  SearchFilters copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    List<String>? foodTypes,
    bool clearCategory = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinRating = false,
    bool clearSortBy = false,
  }) {
    return SearchFilters(
      category: clearCategory ? null : (category ?? this.category),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
      foodTypes: foodTypes ?? this.foodTypes,
    );
  }

  @override
  List<Object?> get props =>
      [category, minPrice, maxPrice, minRating, sortBy, foodTypes];
}

class SearchState extends Equatable {
  final String query;
  final ApiResponse<List<FoodItem>> searchResults;
  final SearchFilters filters;

  const SearchState({
    this.query = '',
    required this.searchResults,
    this.filters = const SearchFilters(),
  });

  factory SearchState.initial() {
    return SearchState(
      query: '',
      searchResults: ApiResponse.initial(),
    );
  }

  SearchState copyWith({
    String? query,
    ApiResponse<List<FoodItem>>? searchResults,
    SearchFilters? filters,
  }) {
    return SearchState(
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [query, searchResults, filters];
}
