import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/api_reospes.dart';
import '../../../model/home/home_model.dart';
import '../../../repo/user/search/search_http_repo.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchHttpRepo searchRepo;

  /// Raw unfiltered results from API
  List<FoodItem> _rawResults = [];

  SearchBloc({required this.searchRepo}) : super(SearchState.initial()) {
    on<SearchFoods>(_onSearchFoods);
    on<ClearSearch>(_onClearSearch);
    on<UpdateFilters>(_onUpdateFilters);
    on<ClearFilters>(_onClearFilters);
    on<RemoveFilter>(_onRemoveFilter);
  }

  Future<void> _onSearchFoods(
    SearchFoods event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      _rawResults = [];
      emit(state.copyWith(
        query: '',
        searchResults: ApiResponse.initial(),
      ));
      return;
    }

    emit(state.copyWith(
      query: event.query,
      searchResults: ApiResponse.loading(),
    ));

    await searchRepo.searchFoods(event.query).then((foods) {
      _rawResults = foods;
      final filtered = _applyFilters(foods, state.filters);
      emit(state.copyWith(
        searchResults: ApiResponse.success(filtered),
      ));
    }).onError((error, stackTrace) {
      emit(state.copyWith(
        searchResults: ApiResponse.error(error.toString()),
      ));
    });
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    _rawResults = [];
    emit(SearchState.initial());
  }

  void _onUpdateFilters(UpdateFilters event, Emitter<SearchState> emit) {
    final filtered = _applyFilters(_rawResults, event.filters);
    emit(state.copyWith(
      filters: event.filters,
      searchResults:
          _rawResults.isEmpty && state.searchResults.isInitial
              ? state.searchResults
              : ApiResponse.success(filtered),
    ));
  }

  void _onClearFilters(ClearFilters event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      filters: const SearchFilters(),
      searchResults:
          _rawResults.isEmpty && state.searchResults.isInitial
              ? state.searchResults
              : ApiResponse.success(_rawResults),
    ));
  }

  void _onRemoveFilter(RemoveFilter event, Emitter<SearchState> emit) {
    final f = state.filters;
    SearchFilters updated;
    switch (event.filterKey) {
      case 'category':
        updated = f.copyWith(clearCategory: true);
        break;
      case 'price':
        updated = f.copyWith(clearMinPrice: true, clearMaxPrice: true);
        break;
      case 'rating':
        updated = f.copyWith(clearMinRating: true);
        break;
      case 'sortBy':
        updated = f.copyWith(clearSortBy: true);
        break;
      case 'foodTypes':
        updated = f.copyWith(foodTypes: []);
        break;
      default:
        return;
    }
    add(UpdateFilters(updated));
  }

  List<FoodItem> _applyFilters(List<FoodItem> foods, SearchFilters filters) {
    if (!filters.hasActiveFilters) return foods;

    var result = foods.where((food) {
      // Category filter
      if (filters.category != null &&
          food.category?.toLowerCase() != filters.category!.toLowerCase()) {
        return false;
      }

      // Price filter
      final price = food.price ?? 0;
      if (filters.minPrice != null && price < filters.minPrice!) return false;
      if (filters.maxPrice != null && price > filters.maxPrice!) return false;

      // Rating filter
      if (filters.minRating != null &&
          (food.rating ?? 0) < filters.minRating!) {
        return false;
      }

      // Food type filter
      if (filters.foodTypes.isNotEmpty) {
        final types = food.foodType?.map((t) => t.toLowerCase()).toList() ?? [];
        final hasMatch = filters.foodTypes
            .any((ft) => types.contains(ft.toLowerCase()));
        if (!hasMatch) return false;
      }

      return true;
    }).toList();

    // Sort
    if (filters.sortBy != null) {
      switch (filters.sortBy) {
        case 'price_low':
          result.sort(
              (a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          break;
        case 'price_high':
          result.sort(
              (a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
          break;
        case 'rating':
          result.sort(
              (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'name':
          result.sort((a, b) =>
              (a.title ?? '').compareTo(b.title ?? ''));
          break;
      }
    }

    return result;
  }
}
