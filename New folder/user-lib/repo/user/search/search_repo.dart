import '../../../model/home/home_model.dart';

abstract class SearchRepo {
  Future<List<FoodItem>> searchFoods(String query);
}
