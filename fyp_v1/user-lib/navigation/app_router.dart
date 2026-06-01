import 'package:get/get.dart';

// Customer Views (user folder)
import '../view/user/address/address_view.dart';
import '../view/user/address/shipping_address_view.dart';
import '../view/user/auth/login/login.dart';
import '../view/user/auth/register/register.dart';
import '../view/user/category/all_category_view.dart';
import '../view/user/category/category_view.dart';
import '../view/user/home/al_lFastestFood.dart';
import '../view/user/home/all_nearby_restaurent.dart';
import '../view/user/home/all_recommendation.dart';
import '../view/user/main/main_view.dart';
import '../view/user/orders/user_order.dart';

// Vendor Views
import '../view/vendor/home/vendor_home_view.dart';

// Route configuration
import 'route_names.dart';
import 'route_guards.dart';

/// Unified App Router combining Customer and Vendor routes
class AppRouter {
  static const Duration _transitionDuration = Duration(milliseconds: 250);
  static const Transition _defaultTransition = Transition.leftToRightWithFade;

  /// Get all application routes
  static List<GetPage> getRoutes() {
    return [
      ..._sharedRoutes,
      ..._customerRoutes,
      ..._vendorRoutes,
      ..._legacyRoutes, // Backward compatibility
    ];
  }

  /// Shared routes (auth, account switching)
  static List<GetPage> get _sharedRoutes => [
        GetPage(
          name: RouteNames.login,
          page: () => const LoginScreen(),
          middlewares: [GuestOnlyMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        GetPage(
          name: RouteNames.register,
          page: () => const RegisterScreen(),
          middlewares: [GuestOnlyMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
      ];

  /// Customer-specific routes
  static List<GetPage> get _customerRoutes => [
        // Main Screen (4-tab navigation)
        GetPage(
          name: RouteNames.customerMain,
          page: () => const MainScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Categories
        GetPage(
          name: RouteNames.allCategories,
          page: () => const AllCategoriesScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        GetPage(
          name: RouteNames.categoryDetail,
          page: () => const CategoryScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Restaurants
        GetPage(
          name: RouteNames.allNearbyRestaurants,
          page: () => const AllNearByRestaurant(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Food
        GetPage(
          name: RouteNames.recommendations,
          page: () => const RecommendationPage(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        GetPage(
          name: RouteNames.fastestFoods,
          page: () => const AllFastestFoods(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Address
        GetPage(
          name: RouteNames.shippingAddress,
          page: () => const ShippingAddressScreen(),
          middlewares: [LoggedInMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        GetPage(
          name: RouteNames.addressPage,
          page: () => const AddressPage(),
          middlewares: [LoggedInMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Orders
        GetPage(
          name: RouteNames.customerOrders,
          page: () => const UserOrderScreen(),
          middlewares: [LoggedInMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
      ];

  /// Vendor-specific routes
  static List<GetPage> get _vendorRoutes => [
        // Vendor Main/Home
        GetPage(
          name: RouteNames.vendorMain,
          page: () => const VendorHomeView(),
          middlewares: [AuthMiddleware(), VendorModeMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Legacy vendor routes for backward compatibility
        GetPage(
          name: '/foodsList',
          page: () => const VendorHomeView(), // Redirect to home for now
          middlewares: [AuthMiddleware(), VendorModeMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        GetPage(
          name: '/addFoodsScreen',
          page: () => const VendorHomeView(), // Redirect to home for now
          middlewares: [AuthMiddleware(), VendorModeMiddleware()],
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
      ];

  /// Legacy routes for backward compatibility
  /// These map old route names to their corresponding screens
  static List<GetPage> get _legacyRoutes => [
        // Old mainScreen route
        GetPage(
          name: '/mainScreen',
          page: () => const MainScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old allCategoriesScreen route
        GetPage(
          name: '/allCategoriesScreen',
          page: () => const AllCategoriesScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old categoriesScreen route
        GetPage(
          name: '/categoriesScreen',
          page: () => const CategoryScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old allNearByRestaurant route
        GetPage(
          name: '/allNearByRestaurant',
          page: () => const AllNearByRestaurant(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old recommendationPage route
        GetPage(
          name: '/recommendationPage',
          page: () => const RecommendationPage(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old allFastestFoods route
        GetPage(
          name: '/allFastestFoods',
          page: () => const AllFastestFoods(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old loginScreen route
        GetPage(
          name: '/loginScreen',
          page: () => const LoginScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old registerScreen route
        GetPage(
          name: '/registerScreen',
          page: () => const RegisterScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old shippingAddressScreen route
        GetPage(
          name: '/shippingAddressScreen',
          page: () => const ShippingAddressScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old addressPage route
        GetPage(
          name: '/addressPage',
          page: () => const AddressPage(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
        // Old userOrderScreen route
        GetPage(
          name: '/userOrderScreen',
          page: () => const UserOrderScreen(),
          transitionDuration: _transitionDuration,
          transition: _defaultTransition,
        ),
      ];
}
