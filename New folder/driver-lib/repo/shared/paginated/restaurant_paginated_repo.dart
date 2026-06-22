import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'paginated_repo.dart';

class RestaurantPaginatedRepo implements PaginatedRepo<RestaurantItem> {
  final _apiServices = NetworkServicesApi();

  @override
  Future<PaginatedResult<RestaurantItem>> fetchItems({int page = 1, int limit = 20}) async {
    final res = await _apiServices.getApi(
      '${AppUrl.restaurantsPaginatedUrl}?page=$page&limit=$limit',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch restaurants");
    }

    return PaginatedResult.fromJson(
      res['data'] as Map<String, dynamic>,
      (json) => RestaurantItem.fromJson(json),
    );
  }
}
