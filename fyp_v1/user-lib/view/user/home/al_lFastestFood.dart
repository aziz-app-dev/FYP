// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/res_imports.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/hooks/fatch_all_fastest_food.dart';
import 'widget/food_tile.dart';

class AllFastestFoods extends HookWidget {
  const AllFastestFoods({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFastestFood();
    // final hookResult = useFetchFoodRecommendation();
    List<FoodModel>? foods = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondary,
        title: const ReuseableText(
          text: 'All Fastest Food',
          fontSize: 13,
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        elevation: 0.3,
      ),
      body: isLoading
          ? const FoodListShimmer()
          : (error != null
              ? Center(child: Text('Error: ${error.toString()}'))
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: foods!.length,
                    itemBuilder: (context, index) {
                      var food = foods[index];
                      return FoodsTile(food: food);
                    },
                  ),
                )),
    );
  }
}
