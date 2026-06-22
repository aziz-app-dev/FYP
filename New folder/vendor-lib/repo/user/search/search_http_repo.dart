import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'search_repo.dart';

class SearchHttpRepo implements SearchRepo {
  final _apiServices = NetworkServicesApi();

  @override
  Future<List<FoodItem>> searchFoods(String query) async {
    try {
      final res = await _apiServices.getApi(
        '${AppUrl.searchFoodsUrl}?q=${Uri.encodeComponent(query)}',
      );

      // Return empty list if no results found
      if (res['status'] == false || res['data'] == null) {
        return [];
      }

      final List<dynamic> data = res['data'] ?? [];
      return data
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return empty list on error instead of throwing
      return [];
    }
  }
}
