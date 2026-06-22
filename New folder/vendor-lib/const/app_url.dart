import 'urls/user_url.dart';
import 'urls/vendor_url.dart';
import 'urls/admin_url.dart';
import 'urls/driver_url.dart';
import '../services/session/session_manger.dart';

export 'urls/user_url.dart';
export 'urls/vendor_url.dart';
export 'urls/admin_url.dart';
export 'urls/driver_url.dart';

class AppUrl {
  static String get baseUrl => UserUrl.baseUrl;

  // Bridge to UserUrl
  static String get loginUrl => UserUrl.loginUrl;
  static String get registerUrl => UserUrl.registerUrl;
  static String get verifyOtpUrl => UserUrl.verifyOtpUrl;
  static String get resendOtpUrl => UserUrl.resendOtpUrl;
  static String get forgotPasswordUrl => UserUrl.forgotPasswordUrl;
  static String get changePasswordUrl => UserUrl.changePasswordUrl;
  static String get sendPhoneOtpUrl => UserUrl.sendPhoneOtpUrl;
  static String get verifyPhoneOtpUrl => UserUrl.verifyPhoneOtpUrl;
  static String get resendPhoneOtpUrl => UserUrl.resendPhoneOtpUrl;
  static String get updatePhoneUrl => UserUrl.updatePhoneUrl;
  static String get userUrl => UserUrl.userUrl;
  static String get verifyUserUrl => UserUrl.verifyUserUrl;
  static String get verifyPhoneUrl => UserUrl.verifyPhoneUrl;
  static String get updateProfileImageUrl => UserUrl.updateProfileImageUrl;
  static String get restaurantUrl => UserUrl.restaurantUrl;
  static String get restaurantsPaginatedUrl => UserUrl.restaurantsPaginatedUrl;
  static String get restaurantByIdUrl => UserUrl.restaurantByIdUrl;
  static String restaurantByQrUrl(String payload) =>
      UserUrl.restaurantByQrUrl(payload);
  static String get foodsByRestaurantUrl => UserUrl.foodsByRestaurantUrl;
  static String get foodUrl => UserUrl.foodUrl;
  static String get foodDetailsUrl => UserUrl.foodDetailsUrl;
  static String get searchFoodsUrl => UserUrl.searchFoodsUrl;
  static String get foodsByCategoryUrl => UserUrl.foodsByCategoryUrl;
  static String get topRatedFoodsUrl => UserUrl.topRatedFoodsUrl;
  static String get allFoodsPaginatedUrl => UserUrl.allFoodsPaginatedUrl;
  static String get cartUrl => UserUrl.cartUrl;
  static String get orderUrl => UserUrl.orderUrl;
  static String get orderHistoryUrl => UserUrl.orderHistoryUrl;
  static String get activeOrdersUrl => UserUrl.activeOrdersUrl;
  static String get orderVerifyUrl => UserUrl.orderVerifyUrl;
  static String get addressUrl => UserUrl.addressUrl;
  static String get homeUrl => UserUrl.homeUrl;
  static String get categoryUrl => UserUrl.categoryUrl;
  static String get dealUrl => UserUrl.dealUrl;
  static String get activeDealUrl => UserUrl.activeDealUrl;
  static String get popularDealUrl => UserUrl.popularDealUrl;
  static String get dealsPaginatedUrl => UserUrl.dealsPaginatedUrl;
  static String get offerUrl => UserUrl.offerUrl;
  static String get activeOfferUrl => UserUrl.activeOfferUrl;
  static String get featuredOfferUrl => UserUrl.featuredOfferUrl;
  static String get offerTypesUrl => UserUrl.offerTypesUrl;
  static String get validatePromoUrl => UserUrl.validatePromoUrl;
  static String get offersPaginatedUrl => UserUrl.offersPaginatedUrl;
  static String get ratingUrl => UserUrl.ratingUrl;
  static String get userRatingsUrl => UserUrl.userRatingsUrl;
  static String get productRatingsUrl => UserUrl.productRatingsUrl;
  static String get wishlistUrl => UserUrl.wishlistUrl;
  static String get reservationUrl => UserUrl.reservationUrl;
  static String get userReservationsUrl => UserUrl.userReservationsUrl;
  static String get reservationSlotsUrl => UserUrl.reservationSlotsUrl;
  static String get reservationInfoUrl => UserUrl.reservationInfoUrl;

  // Bridge to VendorUrl
  static String get myRestaurantsUrl => VendorUrl.myRestaurantsUrl;
  static String get vendorOrdersUrl => VendorUrl.vendorOrdersUrl;
  static String get vendorAnalyticsUrl => VendorUrl.vendorAnalyticsUrl;
  static String get uploadRestaurantImageUrl => VendorUrl.uploadRestaurantImageUrl;
  static String get uploadRestaurantLogoUrl => VendorUrl.uploadRestaurantLogoUrl;
  static String get uploadFoodImagesUrl => VendorUrl.uploadFoodImagesUrl;

  // Bridge to AdminUrl
  static String get settingsUrl => AdminUrl.settingsUrl;
  static String get smsConfigUrl => AdminUrl.smsConfigUrl;

  // Bridge to DriverUrl
  static String get driverRegisterUrl => DriverUrl.driverRegisterUrl;
  static String get driverLoginUrl => DriverUrl.driverLoginUrl;
  static String get driverVerifyOtpUrl => DriverUrl.driverVerifyOtpUrl;
  static String get driverResendOtpUrl => DriverUrl.driverResendOtpUrl;
  static String get driverProfileUrl => DriverUrl.driverProfileUrl;
  static String get driverProfileImageUrl => DriverUrl.driverProfileImageUrl;
  static String get driverChangePasswordUrl => DriverUrl.driverChangePasswordUrl;
  static String get driverOnlineStatusUrl => DriverUrl.driverOnlineStatusUrl;
  static String get driverAvailabilityUrl => DriverUrl.driverAvailabilityUrl;
  static String get driverLocationUrl => DriverUrl.driverLocationUrl;
  static String get driverStatsUrl => DriverUrl.driverStatsUrl;
  static String get driverRatingsUrl => DriverUrl.driverRatingsUrl;
  static String get driverOrderBaseUrl => DriverUrl.orderBaseUrl;
  static String get driverOrdersAvailableUrl => DriverUrl.driverOrdersAvailableUrl;
  static String get driverOrdersActiveUrl => DriverUrl.driverOrdersActiveUrl;
  static String get driverOrdersHistoryUrl => DriverUrl.driverOrdersHistoryUrl;
  static String driverAcceptOrderUrl(String orderId) =>
      DriverUrl.driverAcceptOrderUrl(orderId);
  static String driverCompleteOrderUrl(String orderId) =>
      DriverUrl.driverCompleteOrderUrl(orderId);

  // External APIs
  static String get googlePlacesApiKey {
    final key = SessionManager().googlePlacesApiKey;
    return key.isNotEmpty ? key : UserUrl.defaultGooglePlacesApiKey;
  }

  static String get mapboxAccessToken {
    final key = SessionManager().mapboxAccessToken;
    return key.isNotEmpty ? key : UserUrl.defaultMapboxAccessToken;
  }
}
