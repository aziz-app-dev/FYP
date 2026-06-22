import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/food/food_details_model.dart';
import 'food_repo.dart';

class FoodHttpRepo implements FoodRepo {
  final _apiServices = NetworkServicesApi();

  @override
  Future<FoodDetails> fetchFoodDetails(String foodId) async {
    final res = await _apiServices.getApi('${AppUrl.foodDetailsUrl}/$foodId');

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch food details");
    }

    final data = res['data'];
    if (data == null) {
      throw Exception("Food not found");
    }

    return FoodDetails.fromJson(data as Map<String, dynamic>);
  }
}
