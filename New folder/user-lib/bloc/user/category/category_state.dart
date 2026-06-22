import 'package:equatable/equatable.dart';

import '../../../data/api/api_reospes.dart';
import '../../../model/home/home_model.dart';

class CategoryState extends Equatable {
  final ApiResponse<List<CategoryItem>> categories;
  final ApiResponse<List<FoodItem>> categoryFoods;
  final String? selectedCategoryId;

  const CategoryState({
    required this.categories,
    required this.categoryFoods,
    this.selectedCategoryId,
  });

  factory CategoryState.initial() {
    return CategoryState(
      categories: ApiResponse.initial(),
      categoryFoods: ApiResponse.initial(),
      selectedCategoryId: null,
    );
  }

  CategoryState copyWith({
    ApiResponse<List<CategoryItem>>? categories,
    ApiResponse<List<FoodItem>>? categoryFoods,
    String? selectedCategoryId,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      categoryFoods: categoryFoods ?? this.categoryFoods,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [categories, categoryFoods, selectedCategoryId];
}
