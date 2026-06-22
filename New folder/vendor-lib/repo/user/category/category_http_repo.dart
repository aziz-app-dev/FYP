import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'category_repo.dart';

class CategoryHttpRepo implements CategoryRepo {
  final _apiServices = NetworkServicesApi();

  @override
  Future<List<CategoryItem>> fetchCategories() async {
    final res = await _apiServices.getApi(AppUrl.categoryUrl);

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch categories");
    }

    final List<dynamic> data = res['data'] ?? [];
    return data
        .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FoodItem>> fetchFoodsByCategory(String categoryId) async {
    final res = await _apiServices.getApi(
      '${AppUrl.foodsByCategoryUrl}/$categoryId',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch foods");
    }

    final List<dynamic> data = res['data'] ?? [];
    return data
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
