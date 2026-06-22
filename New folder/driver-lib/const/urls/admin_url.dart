import 'user_url.dart';

class AdminUrl {
  static String get baseUrl => UserUrl.baseUrl;
  static String get adminBaseUrl => "$baseUrl/api/admin";

  // ============= Settings endpoints =============
  static String get settingsUrl => "$baseUrl/api/settings";

  // ============= Auth Config =============
  static String get smsConfigUrl => "$baseUrl/api/auth/sms-config";

  // ============= Categories =============
  static String get categoriesUrl => "$adminBaseUrl/categories";
  static String categoryByIdUrl(String id) => "$adminBaseUrl/categories/$id";

  // ============= Restaurants =============
  static String get restaurantsAdminUrl => "$adminBaseUrl/restaurants";
  static String restaurantByIdAdminUrl(String id) =>
      "$adminBaseUrl/restaurants/$id";

  // ============= Foods =============
  static String get foodsAdminUrl => "$adminBaseUrl/foods";
  static String foodByIdAdminUrl(String id) => "$adminBaseUrl/foods/$id";

  // ============= Users =============
  static String get usersAdminUrl => "$adminBaseUrl/users";
  static String userByIdAdminUrl(String id) => "$adminBaseUrl/users/$id";

  // ============= Orders =============
  static String get ordersAdminUrl => "$adminBaseUrl/orders";
  static String orderByIdUrl(String id) => "$adminBaseUrl/orders/$id";
  static String orderStatusUrl(String id) => "$adminBaseUrl/orders/$id/status";

  // ============= Drivers =============
  static String get driversAdminUrl => "$adminBaseUrl/drivers";
  static String driverByIdAdminUrl(String id) => "$adminBaseUrl/drivers/$id";
  static String verifyDriverAdminUrl(String id) =>
      "$adminBaseUrl/drivers/$id/verify";
  static String activateDriverAdminUrl(String id) =>
      "$adminBaseUrl/drivers/$id/activate";
  static String deactivateDriverAdminUrl(String id) =>
      "$adminBaseUrl/drivers/$id/deactivate";

  // ============= Notifications =============
  static String get globalNotificationUrl => "$adminBaseUrl/notifications/broadcast";

  // ============= Analytics =============
  static String get analyticsUrl => "$adminBaseUrl/analytics/dashboard-summary";
  static String analyticsUserDetailsUrl(String id) => "$adminBaseUrl/analytics/users/$id";
  static String analyticsRestaurantDetailsUrl(String id) => "$adminBaseUrl/analytics/restaurants/$id/details";
  static String analyticsRestaurantOrdersUrl(String id) => "$adminBaseUrl/analytics/restaurants/$id/orders";
  static String get analyticsOwnersUrl => "$adminBaseUrl/analytics/owners";
  static String analyticsOwnerDetailsUrl(String id) => "$adminBaseUrl/analytics/owners/$id";
  static String analyticsDriverDetailsUrl(String id) => "$adminBaseUrl/analytics/drivers/$id/details";

  // ============= Geo Analytics drill-down =============
  static String analyticsCountrySummaryUrl(String country) =>
      "$adminBaseUrl/analytics/country/${Uri.encodeComponent(country)}/summary";
  static String analyticsCitySummaryUrl(String city) =>
      "$adminBaseUrl/analytics/city/${Uri.encodeComponent(city)}/summary";
  static String analyticsCustomerLtvUrl({String? country}) {
    if (country == null || country.isEmpty) {
      return "$adminBaseUrl/analytics/customers/ltv";
    }
    return "$adminBaseUrl/analytics/customers/ltv?country=${Uri.encodeComponent(country)}";
  }

  // ============= Promotions =============
  static String get offersUrl => "$adminBaseUrl/offers";
  static String get dealsUrl => "$adminBaseUrl/deals";
  static String offerByIdUrl(String id) => "$adminBaseUrl/offers/$id";
  static String dealByIdUrl(String id) => "$adminBaseUrl/deals/$id";

  // ============= Reservations =============
  static String get reservationsUrl => "$adminBaseUrl/reservations";
  static String reservationByIdUrl(String id) => "$adminBaseUrl/reservations/$id";
  static String reservationStatusUrl(String id) =>
      "$adminBaseUrl/reservations/$id/status";
}
