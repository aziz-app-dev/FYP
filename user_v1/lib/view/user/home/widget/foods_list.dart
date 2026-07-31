import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../models/food/food_model.dart';
import '../../../../res/res_imports.dart';

import '../../food/foods_view.dart';
import 'food_widget.dart';

class FoodsList extends StatelessWidget {
  final List<FoodModel>? foods;
  final bool isLoading;
  final Exception? error;

  const FoodsList({
    super.key,
    required this.foods,
    required this.isLoading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
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
                      itemCount: foods?.length ?? 0,
                      itemBuilder: (context, index) {
                        var food = foods![index];
                        return FoodsWidget(
                          onTap: () {
                            Get.to(() => FoodScreen(
                                  foods: food,
                                ));
                          },
                          image: food.imageUrl.isNotEmpty == true
                              ? food.imageUrl[0]
                              : '',
                          title: food.title,
                          time: food.time,
                          price: food.price.toString(),
                        );
                      },
                    ),
                  )));
  }
}
