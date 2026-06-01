// ignore_for_file: constant_identifier_names

/// Unified route names for both Customer and Vendor features
class RouteNames {
  // ============ SHARED ROUTES ============
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String phoneVerification = '/phoneVerification';
  static const String accountSwitcher = '/accountSwitcher';

  // ============ CUSTOMER ROUTES ============
  static const String customerMain = '/customer/main';
  static const String customerHome = '/customer/home';
  static const String customerProfile = '/customer/profile';
  static const String customerOrders = '/customer/orders';
  static const String customerCart = '/customer/cart';
  static const String allCategories = '/customer/categories';
  static const String categoryDetail = '/customer/category';
  static const String allNearbyRestaurants = '/customer/restaurants';
  static const String recommendations = '/customer/recommendations';
  static const String fastestFoods = '/customer/fastestFoods';
  static const String shippingAddress = '/customer/shippingAddress';
  static const String addressPage = '/customer/address';
  static const String foodDetail = '/customer/food';
  static const String restaurantDetail = '/customer/restaurant';
  static const String search = '/customer/search';

  // ============ VENDOR ROUTES ============
  static const String vendorMain = '/vendor/main';
  static const String vendorHome = '/vendor/home';
  static const String vendorProfile = '/vendor/profile';
  static const String vendorFoodsList = '/vendor/foods';
  static const String vendorAddFood = '/vendor/addFood';
  static const String vendorEditFood = '/vendor/editFood';
  static const String vendorOrders = '/vendor/orders';
  static const String vendorWallet = '/vendor/wallet';
  static const String vendorSettings = '/vendor/settings';

  // ============ LEGACY ROUTE MAPPING ============
  // These map old route names to new ones for backward compatibility

  /// Maps old customer route names to new ones
  static String mapCustomerRoute(String oldRoute) {
    switch (oldRoute) {
      case '/mainScreen':
        return customerMain;
      case '/allCategoriesScreen':
        return allCategories;
      case '/categoriesScreen':
        return categoryDetail;
      case '/allNearByRestaurant':
        return allNearbyRestaurants;
      case '/recommendationPage':
        return recommendations;
      case '/allFastestFoods':
        return fastestFoods;
      case '/loginScreen':
        return login;
      case '/registerScreen':
        return register;
      case '/shippingAddressScreen':
        return shippingAddress;
      case '/addressPage':
        return addressPage;
      case '/userOrderScreen':
        return customerOrders;
      default:
        return oldRoute;
    }
  }

  /// Maps old vendor route names to new ones
  static String mapVendorRoute(String oldRoute) {
    switch (oldRoute) {
      case '/foodsList':
        return vendorFoodsList;
      case '/addFoodsScreen':
        return vendorAddFood;
      default:
        return oldRoute;
    }
  }
}
