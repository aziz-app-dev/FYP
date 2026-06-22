import 'user_url.dart';

class VendorUrl {
  static String get baseUrl => UserUrl.baseUrl;

  // ============= Vendor Restaurant endpoints =============
  static String get myRestaurantsUrl => "$baseUrl/api/restaurant/my-restaurants";

  // ============= Vendor Order endpoints =============
  static String get vendorOrdersUrl => "$baseUrl/api/vendor/orders";

  // ============= Vendor Analytics endpoints =============
  static String get vendorAnalyticsUrl => "$baseUrl/api/vendor/analytics";

  // ============= Upload endpoints =============
  static String get uploadRestaurantImageUrl => "$baseUrl/api/upload/restaurant";
  static String get uploadRestaurantLogoUrl => "$baseUrl/api/upload/restaurant/logo";
  static String get uploadFoodImagesUrl => "$baseUrl/api/upload/food";
}
