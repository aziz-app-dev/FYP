import 'package:get/get.dart';

import '../../../views/add_foods/add_foods_view.dart';
import '../../../views/auth/login/login_view.dart';
import '../../../views/foods/foods_list_view.dart';
import '../../../views/home/home_view.dart';
import '../../../views/profile/profile_view.dart';
import '../../../views/restaurant/create_restaurant_view.dart';
import '../../../views/restaurant/restaurant_view.dart';
import '../../../views/splash/splash_screen.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: RouteName.LoginScreen,
          page: () => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: RouteName.vendorHome,
          page: () => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: RouteName.FoodsList,
          page: () => const FoodsList(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.AddFoodsScreen,
          page: () => const AddFoodsScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.restaurantScreen,
          page: () => const RestaurantScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.createRestaurant,
          page: () => const CreateRestaurantScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.profile,
          page: () => const ProfileScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.rightToLeft,
        ),
      ];
}
