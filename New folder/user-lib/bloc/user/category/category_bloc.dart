import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/api_reospes.dart';
import '../../../repo/user/category/category_http_repo.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryHttpRepo categoryRepo;

  CategoryBloc({required this.categoryRepo}) : super(CategoryState.initial()) {
    on<FetchCategories>(_onFetchCategories);
    on<FetchCategoryFoods>(_onFetchCategoryFoods);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(categories: ApiResponse.loading()));

    await categoryRepo.fetchCategories().then((categories) {
      emit(state.copyWith(
        categories: ApiResponse.success(categories),
      ));
    }).onError((error, stackTrace) {
      emit(state.copyWith(
        categories: ApiResponse.error(error.toString()),
      ));
    });
  }

  Future<void> _onFetchCategoryFoods(
    FetchCategoryFoods event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      categoryFoods: ApiResponse.loading(),
    ));

    await categoryRepo.fetchFoodsByCategory(event.categoryId).then((foods) {
      emit(state.copyWith(
        categoryFoods: ApiResponse.success(foods),
      ));
    }).onError((error, stackTrace) {
      emit(state.copyWith(
        categoryFoods: ApiResponse.error(error.toString()),
      ));
    });
  }
}
