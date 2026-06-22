import 'package:equatable/equatable.dart';

import 'search_state.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchFoods extends SearchEvent {
  final String query;

  const SearchFoods({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {}

class UpdateFilters extends SearchEvent {
  final SearchFilters filters;

  const UpdateFilters(this.filters);

  @override
  List<Object?> get props => [filters];
}

class ClearFilters extends SearchEvent {}

class RemoveFilter extends SearchEvent {
  final String filterKey;

  const RemoveFilter(this.filterKey);

  @override
  List<Object?> get props => [filterKey];
}
