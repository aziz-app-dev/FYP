import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/hooks/fatch_catgory_food.dart';
import '../../../res/components/shimer/foodslist_shimer.dart';
import '../../../view_models/controller/category/category_view_model.dart';
import '../../home/widget/food_tile.dart';

// class CategoryFoodsList extends HookWidget {
//   const CategoryFoodsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final categoryController = Get.find<CategoryController>();

//     final hookResult = useFetchFoodByCategory(categoryController.categoryValue);
//     List<FoodModel>? foods = hookResult.data;
//     final error = hookResult.error;
//     final isLoading = hookResult.isLoading;

//     return SizedBox(
//       height: height,
//       width: width,
//       child: isLoading
//           ? const FoodListShimmer()
//           : (error != null
//               ? Center(child: Text('Error: ${error.toString()}'))
//               : Padding(
//                   padding: EdgeInsets.all(12.h),
//                   child: ListView(
//                     children: List.generate(
//                       foods!.length,
//                       (index) {
//                         FoodModel food = foods[index];
//                         return FoodsTile(food: food);
//                       },
//                     ),
//                   ),
//                 )),
//     );
//   }
// }
class CategoryFoodsList extends HookWidget {
  const CategoryFoodsList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    final hookResult = useFetchFoodByCategory(categoryController.categoryValue);
    List<FoodModel>? foods = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    return SizedBox(
      height: 200.h, // Adjust height accordingly
      child: isLoading
          ? const FoodListShimmer()
          : (error != null
              ? Center(child: Text('Error: ${error.toString()}'))
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: foods!.length,
                  itemBuilder: (context, index) {
                    return FoodsTile(food: foods[index]);
                  },
                )),
    );
  }
}
