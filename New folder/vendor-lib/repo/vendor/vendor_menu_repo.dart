import '../../const/app_url.dart';
import '../../data/api/network_services_api.dart';
import '../../model/home/home_model.dart';
import '../../services/session/session_manger.dart';

class VendorMenuRepo {
  final _api = NetworkServicesApi();

  Future<String> _getToken() async {
    final token = await SessionManager().getToken();
    if (token == null) throw Exception('Not authenticated');
    return token;
  }

  Future<List<FoodItem>> getMenuItems(String restaurantId) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.foodsByRestaurantUrl}/$restaurantId',
      token,
    );
    final data = res['data'];
    if (data == null || data is! List) return [];
    return data
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createItem(Map<String, dynamic> data) async {
    final token = await _getToken();
    await _api.postApiWithAuth(AppUrl.foodUrl, data, token);
  }

  Future<void> updateItem(String foodId, Map<String, dynamic> data) async {
    final token = await _getToken();
    await _api.putApiWithAuth('${AppUrl.foodUrl}/$foodId', data, token);
  }

  Future<void> deleteItem(String foodId) async {
    final token = await _getToken();
    await _api.deleteApiWithAuth('${AppUrl.foodUrl}/$foodId', token);
  }

  Future<void> toggleAvailability(String foodId) async {
    final token = await _getToken();
    await _api.patchApiWithAuth(
      '${AppUrl.foodUrl}/$foodId',
      {},
      token,
    );
  }
}
