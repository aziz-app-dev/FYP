import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../res/res_imports.dart';

import '../../../models/food/food_model.dart';
import '../../../repository/hooks/fatch_catgory_food.dart';
import '../../../view_models/controller/category/category_view_model.dart';
import '../home/widget/food_tile.dart';

class CategoryScreen extends HookWidget {
  const CategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();

    final hookResult = useFetchFoodByCategory(categoryController.categoryValue);
    List<FoodModel>? foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    return Scaffold(
        appBar: AppBar(
          title: ReuseableText(
            text: categoryController.title.toString(),
            fontSize: 20,
            textColor: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          backgroundColor: kSecondary,
          leading: IconButton(
              onPressed: () {
                categoryController.updateTitle = '';
                categoryController.updateCategory = '';
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Container(
          height: height,
          width: width,
          color: Colors.white,
          padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
          child: isLoading
              ? const FoodListShimmer()
              : ListView(
                  children: List.generate(foods!.length, (i) {
                    FoodModel food = foods[i];
                    return FoodsTile(food: food);
                  }),
                ),
        ));
  }
}
