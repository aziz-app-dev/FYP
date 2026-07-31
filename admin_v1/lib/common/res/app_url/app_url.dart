class AppUrl {
  /// Backend base URL. Same LAN default as the customer/vendor apps;
  /// override at build time without touching code:
  ///   flutter run --dart-define=BASE_URL=http://localhost:5000
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://190.168.0.216:5000',
  );

  // Auth
  static const String loginApi = '$baseUrl/login';

  // Admin — orders
  static const String adminOrdersApi = '$baseUrl/api/order/admin';
  static const String adminStatsApi = '$baseUrl/api/order/admin/stats';
  static String orderStatusApi(String orderId) => '$baseUrl/api/order/$orderId';

  // Admin — restaurants
  static const String adminRestaurantsApi = '$baseUrl/api/restaurant/admin/all';
  static String restaurantVerifyApi(String restaurantId) =>
      '$baseUrl/api/restaurant/verify/$restaurantId';

  // Admin — users
  static const String adminUsersApi = '$baseUrl/api/user/admin/all';
}
