import 'package:get/get.dart';

import '../../../views/add_foods/add_foods_view.dart';
import '../../../views/foods/foods_list_view.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
        // !  food list page
        GetPage(
          name: RouteName.FoodsList,
          page: () => const FoodsList(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // ! add food page
        GetPage(
          name: RouteName.AddFoodsScreen,
          page: () => const AddFoodsScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
