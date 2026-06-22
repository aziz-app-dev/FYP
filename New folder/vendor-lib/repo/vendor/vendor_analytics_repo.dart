import '../../const/app_url.dart';
import '../../data/api/network_services_api.dart';
import '../../model/vendor/vendor_analytics_model.dart';
import '../../model/vendor/vendor_dashboard_model.dart';
import '../../services/session/session_manger.dart';

class VendorAnalyticsRepo {
  final _api = NetworkServicesApi();

  Future<String> _getToken() async {
    final token = await SessionManager().getToken();
    if (token == null) throw Exception('Not authenticated');
    return token;
  }

  Future<RevenueData> getRevenue(
    String restaurantId, {
    String period = 'daily',
  }) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.vendorAnalyticsUrl}/$restaurantId/revenue?period=$period',
      token,
    );
    return RevenueData.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<List<TopSellingItem>> getTopItems(
    String restaurantId, {
    int limit = 10,
  }) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.vendorAnalyticsUrl}/$restaurantId/top-items?limit=$limit',
      token,
    );
    final data = res['data'] as List? ?? [];
    return data
        .map((e) => TopSellingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VendorDashboardSummary> getDashboardSummary(
    String restaurantId,
  ) async {
    final token = await _getToken();
    final res = await _api.getApiWithAuth(
      '${AppUrl.vendorAnalyticsUrl}/$restaurantId/summary',
      token,
    );
    return VendorDashboardSummary.fromJson(res['data'] as Map<String, dynamic>);
  }
}
