import 'package:flutter/material.dart';

import '../model/address/address_model.dart';
import '../model/cart/cart_model.dart';
import '../model/order/order_model.dart';
import '../services/session/session_manger.dart';
import '../ui/user/auth/forgot/forgot_password_screen.dart';
import '../ui/user/auth/login/login_screen.dart';
import '../ui/user/auth/otp/otp_verification_screen.dart';
import '../ui/user/auth/register/register_screen.dart';
import '../ui/user/categories/categories_page.dart';
import '../ui/user/categories/category_foods_page.dart';
import '../ui/user/checkout/checkout_page.dart';
import '../ui/user/deals/all_deals_page.dart';
import '../ui/user/deals/deal_details_page.dart';
import '../ui/user/food/view/food_details_page.dart';
import '../ui/user/food/view/food_details_page_alt.dart';
import '../ui/user/foods/all_foods_page.dart';
import '../ui/user/home/home_screen.dart';
import '../ui/user/main/main_screen.dart';
import '../ui/user/offers/view/all_offers_page.dart';
import '../ui/user/offers/view/offer_details_page.dart';
import '../ui/user/onboarding/one/onboarding_screen.dart';
import '../ui/user/onboarding/three/three_onborad_screen.dart';
import '../ui/user/onboarding/two/two_onbord_screen.dart';
import '../ui/user/order_tracking/order_tracking_screen.dart';
import '../ui/user/orders/qr_scanner_page.dart';
import '../ui/user/profile/view/add_new_address_page.dart';
import '../ui/user/profile/view/address_page.dart';
import '../ui/user/profile/view/edit_profile_page.dart';
import '../ui/user/profile/view/favorite_foods_page.dart';
import '../ui/user/profile/view/my_reviews_page.dart';
import '../ui/user/profile/view/order_history_page.dart';
import '../ui/user/reservation/my_reservations_page.dart';
import '../ui/user/restaurants/restaurant_details_page.dart';
import '../ui/user/restaurants/restaurant_qr_scanner_page.dart';
import '../ui/user/restaurants/all_restaurants_page.dart';
import '../ui/user/reviews/product_reviews_page.dart';
import '../ui/user/search/search_page.dart';
import '../ui/user/settings/app_settings_page.dart';
import '../ui/user/settings/food_card_style_settings_page.dart';
import '../ui/user/splash/splash_screen.dart';
import 'route_name.dart';

class AppRouter {
  /// Routes that require ordering to be enabled
  static const _orderingRoutes = {RouteName.checkout, RouteName.orderTracking};

  static MaterialPageRoute<dynamic> genrateRoute(RouteSettings settings) {
    final session = SessionManager();

    // Redirect ordering routes to MainScreen when ordering is disabled
    if (!session.isOrderingEnabled && _orderingRoutes.contains(settings.name)) {
      return MaterialPageRoute(builder: (_) => const MainScreen());
    }

    switch (settings.name) {
      // Splash & Onboarding
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.userSplash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(entryPoint: 'user'),
        );
      case RouteName.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RouteName.onboardingTwo:
        return MaterialPageRoute(builder: (_) => const OnboardingPageTwo());
      case RouteName.onboardingThree:
        return MaterialPageRoute(builder: (_) => const OnboardingThreeScreen());

      // Auth Screens
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteName.otpVerification:
        final args = settings.arguments as Map<String, String?>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: args?['phoneNumber'],
            email: args?['email'],
            verificationType: args?['verificationType'],
          ),
        );

      // Main App Screens
      case RouteName.mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // Checkout
      case RouteName.checkout:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CheckoutPage(
            cartItems: args?['cartItems'] as List<CartItem>? ?? [],
            subtotal: args?['subtotal'] as double? ?? 0,
            deliveryFee: args?['deliveryFee'] as double? ?? 0,
            taxAmount: args?['taxAmount'] as double? ?? 0,
            discount: args?['discount'] as double? ?? 0,
            total: args?['total'] as double? ?? 0,
            paymentMethod: args?['paymentMethod'] as String? ?? 'cash',
            addressId: args?['addressId'] as String?,
          ),
        );

      // Profile Pages
      case RouteName.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case RouteName.favoriteFoods:
        return MaterialPageRoute(builder: (_) => const FavoriteFoodsPage());
      case RouteName.orderHistory:
        return MaterialPageRoute(builder: (_) => OrderHistoryPage());
      case RouteName.myReviews:
        return MaterialPageRoute(builder: (_) => const MyReviewsPage());
      case RouteName.myAddresses:
        return MaterialPageRoute(builder: (_) => const AddressPage());
      case RouteName.addNewAddress:
        final args = settings.arguments as AddressModel?;
        return MaterialPageRoute(
          builder: (_) => AddNewAddressPage(address: args),
        );

      // Search & Categories
      case RouteName.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case RouteName.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesPage());
      case RouteName.categoryFoods:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CategoryFoodsPage(
            categoryId: args?['categoryId'] as String?,
            categoryName: args?['categoryName'] as String?,
          ),
        );

      // Paginated List Pages
      case RouteName.topRatedFoods:
        return MaterialPageRoute(builder: (_) => const TopRatedFoodsPage());
      case RouteName.allFoods:
        return MaterialPageRoute(builder: (_) => const AllFoodsPage());
      case RouteName.allRestaurants:
        return MaterialPageRoute(builder: (_) => const AllRestaurantsPage());
      case RouteName.allDeals:
        return MaterialPageRoute(builder: (_) => const AllDealsPage());
      case RouteName.allOffers:
        return MaterialPageRoute(builder: (_) => const AllOffersPage());

      // Detail Pages
      case RouteName.foodDetails:
        final foodId = settings.arguments as String? ?? '';
        final pageLayout = SessionManager().foodDetailsConfig.pageLayout;
        return MaterialPageRoute(
          builder: (_) => pageLayout == 'page2'
              ? TwoFoodDetailsPage(foodId: foodId)
              : OneFoodDetailsPage(foodId: foodId),
        );
      case RouteName.foodDetails2:
        final foodId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => TwoFoodDetailsPage(foodId: foodId),
        );
      case RouteName.restaurantDetails:
        final restaurantId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => RestaurantDetailsPage(restaurantId: restaurantId),
        );
      case RouteName.restaurantQrScanner:
        return MaterialPageRoute(
          builder: (_) => const RestaurantQrScannerPage(),
        );
      case RouteName.dealDetails:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => DealDetailsPage(deal: args));
      case RouteName.offerDetails:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => OfferDetailsPage(offer: args));

      // Settings
      case RouteName.cardStyleSettings:
        return MaterialPageRoute(builder: (_) => FoodCardStyleSettingsPage());
      case RouteName.appSettings:
        return MaterialPageRoute(builder: (_) => const AppSettingsPage());

      // Order Tracking
      case RouteName.orderTracking:
        final args = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(order: args),
        );

      // QR Scanner
      case RouteName.qrScanner:
        return MaterialPageRoute(builder: (_) => const QrScannerPage());

      // Product Reviews
      case RouteName.productReviews:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => ProductReviewsPage(
            productId: args['productId'] ?? '',
            ratingType: args['ratingType'] ?? 'Food',
          ),
        );

      // Reservations
      case RouteName.myReservations:
        return MaterialPageRoute(builder: (_) => const MyReservationsPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No route defined'))),
        );
    }
  }
}
