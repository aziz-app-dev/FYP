import 'package:get/get.dart';

import '../../view/user/address/address_view.dart';
import '../../view/user/address/shipping_address_view.dart';
import '../../view/user/auth/login/login.dart';
import '../../view/user/auth/register/register.dart';
import '../../view/user/category/all_category_view.dart';
import '../../view/user/category/category_view.dart';
import '../../view/user/home/al_lFastestFood.dart';
import '../../view/user/home/all_nearby_restaurent.dart';
import '../../view/user/home/all_recommendation.dart';
import '../../view/user/main/main_view.dart';
import '../../view/user/orders/user_order.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
        // !  mainScreen
        GetPage(
          name: RouteName.mainScreen,
          page: () => const MainScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  allCategoriesScreen
        GetPage(
          name: RouteName.allCategoriesScreen,
          page: () => const AllCategoriesScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  categoryScreen
        GetPage(
          name: RouteName.categoryScreen,
          page: () => const CategoryScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  allNearByRestaurant
        GetPage(
          name: RouteName.allNearByRestaurant,
          page: () => const AllNearByRestaurant(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  recommendationPage
        GetPage(
          name: RouteName.recommendationPage,
          page: () => const RecommendationPage(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  allFastestFoods
        GetPage(
          name: RouteName.allFastestFoods,
          page: () => const AllFastestFoods(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  LoginScreen
        GetPage(
          name: RouteName.LoginScreen,
          page: () => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  RegisterScreen
        GetPage(
          name: RouteName.RegisterScreen,
          page: () => const RegisterScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  ShippingAddressScreen
        GetPage(
          name: RouteName.ShippingAddressScreen,
          page: () => const ShippingAddressScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  AddressPage
        GetPage(
          name: RouteName.AddressPage,
          page: () => const AddressPage(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // !  OrdersScreen
        GetPage(
          name: RouteName.UserOrderScreen,
          page: () => const UserOrderScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
