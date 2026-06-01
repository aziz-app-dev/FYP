import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/food/food_model.dart';
import '../../../res/res_imports.dart';
import '../../../view_models/controller/search/search_view_model.dart';
import '../home/widget/food_tile.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(FoodSearchController());

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.h, 0),
      height: height,
      child: ListView.builder(
        itemCount: searchController.searchFoodList.length,
        itemBuilder: (context, index) {
          FoodModel food = searchController.searchFoodList[index];
          return FoodsTile(food: food);
        },
      ),
    );
  }
}
