import 'user_url.dart';

class DriverUrl {
  static String get baseUrl => UserUrl.baseUrl;
  static String get driverBaseUrl => '$baseUrl/api/driver';

  // Auth
  static String get driverRegisterUrl => '$driverBaseUrl/register';
  static String get driverLoginUrl => '$driverBaseUrl/login';
  static String get driverVerifyOtpUrl => '$driverBaseUrl/verify-otp';
  static String get driverResendOtpUrl => '$driverBaseUrl/resend-otp';

  // Profile
  static String get driverProfileUrl => '$driverBaseUrl/profile';
  static String get driverProfileImageUrl => '$driverBaseUrl/profile-image';
  static String get driverChangePasswordUrl => '$driverBaseUrl/change-password';

  // Driver state
  static String get driverOnlineStatusUrl => '$driverBaseUrl/status/online';
  static String get driverAvailabilityUrl => '$driverBaseUrl/status/availability';
  static String get driverLocationUrl => '$driverBaseUrl/location';

  // Stats and quality
  static String get driverStatsUrl => '$driverBaseUrl/stats';
  static String get driverRatingsUrl => '$driverBaseUrl/ratings';

  // Order actions
  static String get orderBaseUrl => '$baseUrl/api/order';
  static String get driverOrdersAvailableUrl => '$driverBaseUrl/orders/available';
  static String get driverOrdersActiveUrl => '$driverBaseUrl/orders/active';
  static String get driverOrdersHistoryUrl => '$driverBaseUrl/orders/history';
  static String driverAcceptOrderUrl(String orderId) =>
      '$driverBaseUrl/orders/$orderId/accept';
  static String driverCompleteOrderUrl(String orderId) =>
      '$driverBaseUrl/orders/$orderId/complete';
}
