import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoryEvent {}

class FetchCategoryFoods extends CategoryEvent {
  final String categoryId;

  const FetchCategoryFoods({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
