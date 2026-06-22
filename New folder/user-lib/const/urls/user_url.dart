import 'dart:io';

class UserUrl {
  static const _baseUrls = [
    "http://192.168.100.159:5000",
    "http://192.168.100.117:5000",
    "http://10.16.198.149:5000",
    "http://190.168.0.216:5000", // office
  ];

  static String _activeBaseUrl = _baseUrls.first;
  static bool _initialized = false;

  static String get baseUrl => _activeBaseUrl;

  /// Call once at app startup to find a reachable server.
  static Future<void> init() async {
    if (_initialized) return;
    for (final url in _baseUrls) {
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 3);
        final request = await client.getUrl(Uri.parse('$url/api/health'));
        final response = await request.close();
        await response.drain();
        client.close();
        if (response.statusCode < 500) {
          _activeBaseUrl = url;
          _initialized = true;
          print('Connected to server: $url');
          return;
        }
      } catch (_) {
        // try next URL
      }
    }
    // fallback to first if none reachable
    _activeBaseUrl = _baseUrls.first;
    _initialized = true;
    print('No server reachable, defaulting to: $_activeBaseUrl');
  }

  // ============= Auth endpoints =============
  static String get loginUrl => "$baseUrl/api/auth/login";
  static String get registerUrl => "$baseUrl/api/auth/register";
  static String get verifyOtpUrl => "$baseUrl/api/auth/verify-otp";
  static String get resendOtpUrl => "$baseUrl/api/auth/resend-otp";
  static String get forgotPasswordUrl => "$baseUrl/api/auth/forgot-password";
  static String get changePasswordUrl => "$baseUrl/api/auth/change-password";

  // ============= Phone OTP endpoints =============
  static String get sendPhoneOtpUrl => "$baseUrl/api/auth/send-phone-otp";
  static String get verifyPhoneOtpUrl => "$baseUrl/api/auth/verify-phone-otp";
  static String get resendPhoneOtpUrl => "$baseUrl/api/auth/resend-phone-otp";
  static String get updatePhoneUrl => "$baseUrl/api/auth/update-phone";

  // ============= User endpoints =============
  static String get userUrl => "$baseUrl/api/user";
  static String get verifyUserUrl => "$baseUrl/api/user/varify";
  static String get verifyPhoneUrl => "$baseUrl/api/user/varify-phone";
  static String get updateProfileImageUrl => "$baseUrl/api/user/profile-image";

  // ============= Restaurant endpoints =============
  static String get restaurantUrl => "$baseUrl/api/restaurant";
  static String get restaurantsPaginatedUrl =>
      "$baseUrl/api/restaurant/paginated";
  static String get restaurantByIdUrl => "$baseUrl/api/restaurant/byId";
  static String get foodsByRestaurantUrl => "$baseUrl/api/foods/byRestaurant";
  static String restaurantByQrUrl(String payload) =>
      "$baseUrl/api/restaurant/by-qr/${Uri.encodeComponent(payload)}";

  // ============= Food endpoints =============
  static String get foodUrl => "$baseUrl/api/foods";
  static String get foodDetailsUrl => "$baseUrl/api/foods";
  static String get searchFoodsUrl => "$baseUrl/api/foods/search";
  static String get foodsByCategoryUrl => "$baseUrl/api/foods/category";
  static String get topRatedFoodsUrl => "$baseUrl/api/foods/top-rated";
  static String get allFoodsPaginatedUrl => "$baseUrl/api/foods/paginated";

  // ============= Cart endpoints =============
  static String get cartUrl => "$baseUrl/api/cart";

  // ============= Order endpoints =============
  static String get orderUrl => "$baseUrl/api/order";
  static String get orderHistoryUrl => "$baseUrl/api/order/history";
  static String get activeOrdersUrl => "$baseUrl/api/order/active";
  static String get orderVerifyUrl => "$baseUrl/api/order/verify";

  // ============= Address endpoints =============
  static String get addressUrl => "$baseUrl/api/address";

  // ============= Home endpoint =============
  static String get homeUrl => "$baseUrl/api/home";

  // ============= Category endpoints =============
  static String get categoryUrl => "$baseUrl/api/category";

  // ============= Deal endpoints =============
  static String get dealUrl => "$baseUrl/api/deals";
  static String get activeDealUrl => "$baseUrl/api/deals/active";
  static String get popularDealUrl => "$baseUrl/api/deals/popular";
  static String get dealsPaginatedUrl => "$baseUrl/api/deals/paginated";

  // ============= Offer endpoints =============
  static String get offerUrl => "$baseUrl/api/offers";
  static String get activeOfferUrl => "$baseUrl/api/offers/active";
  static String get featuredOfferUrl => "$baseUrl/api/offers/featured";
  static String get offerTypesUrl => "$baseUrl/api/offers/types";
  static String get validatePromoUrl => "$baseUrl/api/offers/validate-promo";
  static String get offersPaginatedUrl => "$baseUrl/api/offers/paginated";

  // ============= Rating endpoints =============
  static String get ratingUrl => "$baseUrl/api/rating";
  static String get userRatingsUrl => "$baseUrl/api/rating/user";
  static String get productRatingsUrl => "$baseUrl/api/rating/product";

  // ============= Wishlist endpoints =============
  static String get wishlistUrl => "$baseUrl/api/wishlist";

  // ============= Reservation endpoints =============
  static String get reservationUrl => "$baseUrl/api/reservation";
  static String get userReservationsUrl => "$baseUrl/api/reservation/user";
  static String get reservationSlotsUrl => "$baseUrl/api/reservation/slots";
  static String get reservationInfoUrl => "$baseUrl/api/reservation/info";

  // ============= External APIs =============
  static const defaultGooglePlacesApiKey =
      "AIzaSyAaUwLnEmLlUS5B_tHjLvesYARTheTktus";
  static const defaultMapboxAccessToken = "YOUR_MAPBOX_ACCESS_TOKEN";
}
