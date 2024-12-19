import '../../data/network/network_api_services.dart';
import '../../models/food/food_model.dart';
import '../../res/app_url/app_url.dart';

class SearchRepository {
  final _apiService = NetworkApiServices();

  Future<List<FoodModel>> searchApi(String text) async {
    dynamic response = await _apiService.getApi(AppUrl.foodsSearchApi + text);
    // print('API Response: $response');

    // Ensure the response is a list of categories
    if (response is List) {
      List<FoodModel> food =
          response.map((data) => FoodModel.fromJson(data)).toList();
      return food;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
