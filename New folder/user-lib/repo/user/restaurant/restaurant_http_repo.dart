import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'restaurant_repo.dart';

class RestaurantHttpRepo implements RestaurantRepo {
  final _apiServices = NetworkServicesApi();

  @override
  Future<RestaurantItem> fetchRestaurantById(String restaurantId) async {
    final res = await _apiServices.getApi(
      '${AppUrl.restaurantByIdUrl}/$restaurantId',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? 'Failed to fetch restaurant');
    }

    final data = res['data'];
    if (data == null) {
      throw Exception('Restaurant not found');
    }

    return RestaurantItem.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<RestaurantItem> fetchRestaurantByQr(String payload) async {
    final res = await _apiServices.getApi(AppUrl.restaurantByQrUrl(payload));

    if (res['status'] == false) {
      throw Exception(res['message'] ?? 'Restaurant not found for this QR');
    }

    final data = res['data'];
    if (data == null) {
      throw Exception('Restaurant not found for this QR');
    }

    return RestaurantItem.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<FoodItem>> fetchFoodsByRestaurant(String restaurantId) async {
    final res = await _apiServices.getApi(
      '${AppUrl.foodsByRestaurantUrl}/$restaurantId',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? 'Failed to fetch foods');
    }

    final data = res['data'];
    if (data == null || data is! List) return [];

    return data
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<DealItem>> fetchDealsByRestaurant(String restaurantId) async {
    final res = await _apiServices.getApi(
      '${AppUrl.dealUrl}/restaurant/$restaurantId',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? 'Failed to fetch deals');
    }

    final data = res['data'];
    if (data == null || data is! List) return [];

    return data
        .map((e) => DealItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<OfferItem>> fetchOffersByRestaurant(String restaurantId) async {
    final res = await _apiServices.getApi(
      '${AppUrl.offerUrl}/restaurant/$restaurantId',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? 'Failed to fetch offers');
    }

    final data = res['data'];
    if (data == null || data is! List) return [];

    return data
        .map((e) => OfferItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
