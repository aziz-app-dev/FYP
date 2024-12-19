import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/hooks/fatch_all_food.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/shimer/foodslist_shimer.dart';
import '../../home/widget/food_tile.dart';

class ExploreWidget extends HookWidget {
  const ExploreWidget({super.key, required this.resturantId});
  final String resturantId;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFoodRecommendation(context);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    return Scaffold(
      backgroundColor: kLightWhite,
      body: isLoading
          ? const FoodListShimmer()
          : Container(
              height: height * 0.7,
              color: Colors.white,
              padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
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
