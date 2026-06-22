import '../../const/app_url.dart';
import '../../data/api/network_services_api.dart';
import '../../model/driver/driver_model.dart';
import '../../model/order/order_model.dart';

class DriverRepo {
  final _api = NetworkServicesApi();

  List<OrderModel> _parseOrders(List<dynamic> raw) {
    final orders = <OrderModel>[];
    for (final item in raw) {
      try {
        if (item is Map<String, dynamic>) {
          orders.add(OrderModel.fromJson(item));
        }
      } catch (_) {}
    }
    return orders;
  }

  Future<DriverModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.postApi(AppUrl.driverLoginUrl, {
      'email': email,
      'password': password,
    });
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final token = data['token']?.toString();
    final driver = data['driver'] as Map<String, dynamic>? ?? {};
    return DriverModel.fromJson(driver, token: token);
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String vehicleType = 'bike',
  }) async {
    await _api.postApi(AppUrl.driverRegisterUrl, {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'vehicleType': vehicleType,
    });
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await _api.postApi(AppUrl.driverVerifyOtpUrl, {
      'email': email,
      'otp': otp,
    });
  }

  Future<void> resendOtp({required String email}) async {
    await _api.postApi(AppUrl.driverResendOtpUrl, {'email': email});
  }

  Future<DriverModel> getProfile(String token) async {
    final response = await _api.getApiWithAuth(AppUrl.driverProfileUrl, token);
    return DriverModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<DriverStatsModel> getStats(String token) async {
    final response = await _api.getApiWithAuth(AppUrl.driverStatsUrl, token);
    return DriverStatsModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<DriverRatingModel>> getRatings(String token) async {
    final response = await _api.getApiWithAuth(AppUrl.driverRatingsUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(DriverRatingModel.fromJson)
        .toList();
  }

  Future<void> updateOnlineStatus({
    required String token,
    required bool isOnline,
  }) async {
    await _api.putApiWithAuth(
      AppUrl.driverOnlineStatusUrl,
      {'isOnline': isOnline},
      token,
    );
  }

  Future<void> updateAvailability({
    required String token,
    required bool isAvailable,
  }) async {
    await _api.putApiWithAuth(
      AppUrl.driverAvailabilityUrl,
      {'isAvailable': isAvailable},
      token,
    );
  }

  Future<void> updateLocation({
    required String token,
    required double latitude,
    required double longitude,
  }) async {
    await _api.putApiWithAuth(
      AppUrl.driverLocationUrl,
      {'latitude': latitude, 'longitude': longitude},
      token,
    );
  }

  Future<void> assignDriverToOrder({
    required String token,
    required String orderId,
    required DriverModel driver,
  }) async {
    final url = '${AppUrl.driverOrderBaseUrl}/$orderId/assign-driver';
    await _api.putApiWithAuth(url, {
      'driverId': driver.id,
      'driverName': driver.name,
      'driverPhone': driver.phone,
      'driverImage': driver.profile,
      'vehicleType': driver.vehicleType,
      'vehicleNumber': driver.vehicleNumber,
    }, token);
  }

  Future<void> updateOrderDriverLocation({
    required String token,
    required String orderId,
    required double latitude,
    required double longitude,
  }) async {
    final url = '${AppUrl.driverOrderBaseUrl}/$orderId/driver-location';
    await _api.putApiWithAuth(url, {
      'driverLat': latitude,
      'driverLng': longitude,
    }, token);
  }

  Future<List<OrderModel>> getAvailableOrders(String token) async {
    final response = await _api.getApiWithAuth(AppUrl.driverOrdersAvailableUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return _parseOrders(data);
  }

  Future<List<OrderModel>> getActiveOrders(String token) async {
    final response = await _api.getApiWithAuth(AppUrl.driverOrdersActiveUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return _parseOrders(data);
  }

  Future<List<OrderModel>> getOrderHistory(String token) async {
    final response = await _api.getApiWithAuth(AppUrl.driverOrdersHistoryUrl, token);
    final data = response['data'] as List<dynamic>? ?? [];
    return _parseOrders(data);
  }

  Future<OrderModel> acceptOrder({
    required String token,
    required String orderId,
  }) async {
    final response = await _api.putApiWithAuth(
      AppUrl.driverAcceptOrderUrl(orderId),
      {},
      token,
    );
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<OrderModel> completeOrder({
    required String token,
    required String orderId,
    required String verificationCode,
  }) async {
    final response = await _api.putApiWithAuth(
      AppUrl.driverCompleteOrderUrl(orderId),
      {'verificationCode': verificationCode},
      token,
    );
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
