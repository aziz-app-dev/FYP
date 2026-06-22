import '../../../model/home/home_model.dart';

abstract class RestaurantRepo {
  Future<RestaurantItem> fetchRestaurantById(String restaurantId);
  Future<RestaurantItem> fetchRestaurantByQr(String payload);
  Future<List<FoodItem>> fetchFoodsByRestaurant(String restaurantId);
  Future<List<DealItem>> fetchDealsByRestaurant(String restaurantId);
  Future<List<OfferItem>> fetchOffersByRestaurant(String restaurantId);
}
