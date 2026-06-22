import '../../../model/home/home_model.dart';

abstract class CategoryRepo {
  Future<List<CategoryItem>> fetchCategories();
  Future<List<FoodItem>> fetchFoodsByCategory(String categoryId);
}
