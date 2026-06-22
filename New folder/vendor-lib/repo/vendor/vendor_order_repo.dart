import '../../const/app_url.dart';
import '../../data/api/network_services_api.dart';
import '../../model/vendor/vendor_dashboard_model.dart';
import '../../model/vendor/vendor_order_model.dart';
import '../../services/session/session_manger.dart';

class VendorOrderRepo {
  final _api = NetworkServicesApi();

  Future<String> _getToken() async {
    final token = await SessionManager().getToken();
    if (token == null) throw Exception('Not authenticated');
    return token;
  }

  Future<({List<VendorOrder> orders, int totalPages, int totalItems})>
      getOrders(
    String restaurantId, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final token = await _getToken();
    final params = <String, String>{'page': '$page', 'limit': '$limit'};
    if (status != null) params['status'] = status;

    final queryString = Uri(queryParameters: params).query;
    final url = '${AppUrl.vendorOrdersUrl}/$restaurantId?$queryString';
    final res = await _api.getApiWithAuth(url, token);
    final data = res['data'];

    final items = data['items'] as List? ?? [];
    return (
      orders: items
          .map((e) => VendorOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (data['totalPages'] as int?) ?? 1,
      totalItems: (data['totalItems'] as int?) ?? 0,
    );
  }

  Future<VendorOrder> getOrderById(String orderId) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.vendorOrdersUrl}/detail/$orderId',
      token,
    );
    return VendorOrder.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<VendorOrder> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    final token = await _getToken();
    final res = await _api.patchApiWithAuth(
      '${AppUrl.vendorOrdersUrl}/$orderId/status',
      {'orderStatus': newStatus},
      token,
    );
    return VendorOrder.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<VendorQuickStats> getQuickStats(String restaurantId) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.vendorOrdersUrl}/$restaurantId/stats',
      token,
    );
    return VendorQuickStats.fromJson(res['data'] as Map<String, dynamic>);
  }
}
