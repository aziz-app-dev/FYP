import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/hooks/fatch_all_food.dart';
import '../../../res/components/shimer/nearby_shimer.dart';
import '../../food/foods_view.dart';
import 'food_widget.dart';

class FoodsList extends StatefulHookWidget {
  const FoodsList({super.key});

  @override
  State<FoodsList> createState() => _FoodsListState();
}

class _FoodsListState extends State<FoodsList> {
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFoodRecommendation(context);
    List<FoodModel>? foods = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    return Container(
        height: 190.h,
        padding: EdgeInsets.only(top: 10.h),
        child: isLoading
            ? const NearbyShimmer()
            : (error != null
                ? Center(child: Text('Error: ${error.toString()}'))
                : Container(
                    height: 205.h,
                    padding: EdgeInsets.only(left: 12.w, top: 10.h),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: foods!.length,
                      itemBuilder: (context, index) {
                        var food = foods[index];
                        return FoodsWidget(
                          onTap: () {
                            Get.to(() => FoodScreen(
                                  foods: food,
                                ));
                          },
                          image: food.imageUrl.isNotEmpty == true
                              ? food.imageUrl[0]
                              : '', // Use first image URL
                          title: food.title,
                          time: food.time,
                          price: food.price.toString(),
                        );
                      },
                    ),
                  )));
  }
}
