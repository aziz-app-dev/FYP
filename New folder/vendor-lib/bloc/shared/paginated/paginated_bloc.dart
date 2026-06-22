import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/api_reospes.dart';
import '../../../repo/shared/paginated/paginated_repo.dart';
import 'paginated_event.dart';
import 'paginated_state.dart';

class PaginatedBloc<T> extends Bloc<PaginatedEvent, PaginatedState<T>> {
  final PaginatedRepo<T> repo;
  final int pageSize;

  PaginatedBloc({required this.repo, this.pageSize = 10})
      : super(PaginatedState.initial()) {
    on<FetchItems>(_onFetchItems);
    on<LoadMoreItems>(_onLoadMoreItems);
  }

  Future<void> _onFetchItems(
    FetchItems event,
    Emitter<PaginatedState<T>> emit,
  ) async {
    emit(state.copyWith(
      items: ApiResponse.loading(),
      currentPage: 1,
      hasMore: true,
    ));

    try {
      final result = await repo.fetchItems(page: 1, limit: pageSize);
      emit(state.copyWith(
        items: ApiResponse.success(result.items),
        currentPage: result.currentPage,
        hasMore: result.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(items: ApiResponse.error(e.toString())));
    }
  }

  Future<void> _onLoadMoreItems(
    LoadMoreItems event,
    Emitter<PaginatedState<T>> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore || state.items.isLoading) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final result = await repo.fetchItems(page: nextPage, limit: pageSize);

      final currentItems = state.items.data ?? [];
      final newItems = [...currentItems, ...result.items];

      emit(state.copyWith(
        items: ApiResponse.success(newItems),
        currentPage: result.currentPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
