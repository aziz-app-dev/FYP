import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/hooks/fatch_food_by_restaurant.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/shimer/foodslist_shimer.dart';
import '../../home/widget/food_tile.dart';

class RestaurantMenuWidget extends HookWidget {
  const RestaurantMenuWidget({super.key, required this.resturantId});
  final String resturantId;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRestaurantFoods(resturantId);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    return Scaffold(
      backgroundColor: kLightWhite,
      body: isLoading
          ? const FoodListShimmer()
          : Container(
              height: height * 0.7,
              color: Colors.white,
              padding: EdgeInsets.only(left: 8.w, top: 10.h, right: 8.w),
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: List.generate(
                  foods!.length,
                  (index) {
                    final FoodModel food = foods[index];
                    return FoodsTile(food: food);
                  },
                ),
              ),
            ),
    );
  }
}
