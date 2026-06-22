import '../../../model/food/food_details_model.dart';

abstract class FoodRepo {
  Future<FoodDetails> fetchFoodDetails(String foodId);
}
