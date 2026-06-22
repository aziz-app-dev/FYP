import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'paginated_repo.dart';

class TopRatedFoodsRepo implements PaginatedRepo<FoodItem> {
  final _apiServices = NetworkServicesApi();

  @override
  Future<PaginatedResult<FoodItem>> fetchItems({int page = 1, int limit = 20}) async {
    final res = await _apiServices.getApi(
      '${AppUrl.topRatedFoodsUrl}?page=$page&limit=$limit',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch foods");
    }

    return PaginatedResult.fromJson(
      res['data'] as Map<String, dynamic>,
      (json) => FoodItem.fromJson(json),
    );
  }
}

class AllFoodsRepo implements PaginatedRepo<FoodItem> {
  final _apiServices = NetworkServicesApi();

  @override
  Future<PaginatedResult<FoodItem>> fetchItems({int page = 1, int limit = 20}) async {
    final res = await _apiServices.getApi(
      '${AppUrl.allFoodsPaginatedUrl}?page=$page&limit=$limit',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch foods");
    }

    return PaginatedResult.fromJson(
      res['data'] as Map<String, dynamic>,
      (json) => FoodItem.fromJson(json),
    );
  }
}
