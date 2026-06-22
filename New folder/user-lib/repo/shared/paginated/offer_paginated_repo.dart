import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/home/home_model.dart';
import 'paginated_repo.dart';

class OfferPaginatedRepo implements PaginatedRepo<OfferItem> {
  final _apiServices = NetworkServicesApi();

  @override
  Future<PaginatedResult<OfferItem>> fetchItems({int page = 1, int limit = 20}) async {
    final res = await _apiServices.getApi(
      '${AppUrl.offersPaginatedUrl}?page=$page&limit=$limit',
    );

    if (res['status'] == false) {
      throw Exception(res['message'] ?? "Failed to fetch offers");
    }

    return PaginatedResult.fromJson(
      res['data'] as Map<String, dynamic>,
      (json) => OfferItem.fromJson(json),
    );
  }
}
