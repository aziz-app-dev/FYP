import '../../const/app_url.dart';
import '../../data/api/network_services_api.dart';
import '../../model/home/home_model.dart';
import '../../services/session/session_manger.dart';

class VendorRestaurantRepo {
  final _api = NetworkServicesApi();

  Future<String> _getToken() async {
    final token = await SessionManager().getToken();
    if (token == null) throw Exception('Not authenticated');
    return token;
  }

  Future<List<RestaurantItem>> getMyRestaurants() async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(AppUrl.myRestaurantsUrl, token);
    final data = res['data'];
    if (data == null) return [];
    final list = data['restaurants'] as List? ?? [];
    return list
        .map((e) => RestaurantItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<RestaurantItem> getMyRestaurantById(String restaurantId) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.myRestaurantsUrl}/$restaurantId',
      token,
    );
    final data = res['data'];
    if (data == null || data['restaurant'] == null) {
      throw Exception('Restaurant not found');
    }
    return RestaurantItem.fromJson(data['restaurant'] as Map<String, dynamic>);
  }

  Future<void> createRestaurant(Map<String, dynamic> data) async {
    final token = await _getToken();
    await _api.postApiWithAuth(AppUrl.restaurantUrl, data, token);
  }

  Future<RestaurantItem> updateRestaurant(
    String restaurantId,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final res = await _api.putApiWithAuth(
      '${AppUrl.myRestaurantsUrl}/$restaurantId',
      data,
      token,
    );
    return RestaurantItem.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> toggleAvailability(String restaurantId) async {
    final token = await _getToken();
    await _api.patchApiWithAuth(
      '${AppUrl.restaurantUrl}/$restaurantId',
      {},
      token,
    );
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    final token = await _getToken();
    await _api.deleteApiWithAuth(
      '${AppUrl.restaurantUrl}/$restaurantId',
      token,
    );
  }
}
