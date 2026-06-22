import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/address/address_model.dart';

class AddressRepo {
  final api = NetworkServicesApi();

  /// Get all addresses for the logged-in user
  /// Endpoint: GET /api/address
  Future<List<AddressModel>> getUserAddresses(String token) async {
    final response = await api.getApiWithAuth(AppUrl.addressUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => AddressModel.fromJson(json)).toList();
  }

  /// Get default address
  /// Endpoint: GET /api/address/default
  Future<AddressModel?> getDefaultAddress(String token) async {
    try {
      final response = await api.getApiWithAuth(
        '${AppUrl.addressUrl}/default',
        token,
      );
      if (response['data'] != null) {
        return AddressModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Create a new address
  /// Endpoint: POST /api/address
  Future<AddressModel> createAddress(
    Map<String, dynamic> addressData,
    String token,
  ) async {
    final response = await api.postApiWithAuth(
      AppUrl.addressUrl,
      addressData,
      token,
    );
    return AddressModel.fromJson(response['data']);
  }

  /// Update an existing address
  /// Endpoint: PUT /api/address/:id
  Future<AddressModel> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
    String token,
  ) async {
    final response = await api.putApiWithAuth(
      '${AppUrl.addressUrl}/$addressId',
      addressData,
      token,
    );
    return AddressModel.fromJson(response['data']);
  }

  /// Delete an address
  /// Endpoint: DELETE /api/address/:id
  Future<bool> deleteAddress(String addressId, String token) async {
    await api.deleteApiWithAuth(
      '${AppUrl.addressUrl}/$addressId',
      token,
    );
    return true;
  }

  /// Set an address as default
  /// Endpoint: PUT /api/address/:id with default: true
  Future<AddressModel> setDefaultAddress(String addressId, String token) async {
    final response = await api.putApiWithAuth(
      '${AppUrl.addressUrl}/$addressId',
      {'default': true},
      token,
    );
    return AddressModel.fromJson(response['data']);
  }
}
