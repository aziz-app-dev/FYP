import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../data/exceptions/api_error_response.dart';

class DealRepo {
  final _api = NetworkServicesApi();

  /// Helper method to check for API errors
  void _checkForError(dynamic response) {
    if (response['status'] == false) {
      throw ApiErrorResponse.fromJson(response);
    }
  }

  /// Get all active deals
  Future<List<dynamic>> getActiveDeals() async {
    final response = await _api.getApi(AppUrl.activeDealUrl);
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get popular deals
  Future<List<dynamic>> getPopularDeals() async {
    final response = await _api.getApi(AppUrl.popularDealUrl);
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get deal by ID
  Future<Map<String, dynamic>> getDealById(String dealId) async {
    final response = await _api.getApi('${AppUrl.dealUrl}/$dealId');
    _checkForError(response);
    return response['data'] as Map<String, dynamic>;
  }

  /// Get deals by restaurant
  Future<List<dynamic>> getDealsByRestaurant(String restaurantId) async {
    final response = await _api.getApi('${AppUrl.dealUrl}/restaurant/$restaurantId');
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get deals by type
  Future<List<dynamic>> getDealsByType(String dealType) async {
    final response = await _api.getApi('${AppUrl.dealUrl}/type/$dealType');
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }
}
