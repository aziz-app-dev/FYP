import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'paginated_repo.dart';

class DealPaginatedRepo implements PaginatedRepo<DealItem> {
  final _apiServices = NetworkServicesApi();

  @override
  Future<PaginatedResult<DealItem>> fetchItems({int page = 1, int limit = 20}) async {
    final res = await _apiServices.getApi(
      '${AppUrl.dealsPaginatedUrl}?page=$page&limit=$limit',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch deals");
    }

    return PaginatedResult.fromJson(
      res['data'] as Map<String, dynamic>,
      (json) => DealItem.fromJson(json),
    );
  }
}
