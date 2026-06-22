import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../data/exceptions/api_error_response.dart';

class OfferRepo {
  final _api = NetworkServicesApi();

  /// Helper method to check for API errors
  void _checkForError(dynamic response) {
    if (response['status'] == false) {
      throw ApiErrorResponse.fromJson(response);
    }
  }

  /// Get all active offers
  Future<List<dynamic>> getActiveOffers() async {
    final response = await _api.getApi(AppUrl.activeOfferUrl);
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get featured offers
  Future<List<dynamic>> getFeaturedOffers() async {
    final response = await _api.getApi(AppUrl.featuredOfferUrl);
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get offer by ID (includes restaurant list and foods based on logic)
  Future<Map<String, dynamic>> getOfferById(String offerId) async {
    final response = await _api.getApi('${AppUrl.offerUrl}/$offerId');
    _checkForError(response);
    return response['data'] as Map<String, dynamic>;
  }

  /// Get offers by restaurant
  Future<List<dynamic>> getOffersByRestaurant(String restaurantId) async {
    final response = await _api.getApi('${AppUrl.offerUrl}/restaurant/$restaurantId');
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get offers by type
  Future<List<dynamic>> getOffersByType(String offerType) async {
    final response = await _api.getApi('${AppUrl.offerUrl}/type/$offerType');
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Get all offer types
  Future<List<dynamic>> getOfferTypes() async {
    final response = await _api.getApi(AppUrl.offerTypesUrl);
    _checkForError(response);
    return response['data'] as List<dynamic>;
  }

  /// Validate promo code
  Future<Map<String, dynamic>> validatePromoCode({
    required String promoCode,
    String? restaurantId,
    required double orderAmount,
  }) async {
    final response = await _api.postApi(
      AppUrl.validatePromoUrl,
      {
        'promoCode': promoCode,
        if (restaurantId != null) 'restaurantId': restaurantId,
        'orderAmount': orderAmount,
      },
    );
    _checkForError(response);
    return response['data'] as Map<String, dynamic>;
  }
}
