import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/food/food_model.dart';
import '../../repository/hooks/fatch_all_food.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/reuseable_text.dart';
import '../../res/components/shimer/foodslist_shimer.dart';
import 'widget/food_tile.dart';

class RecommendationPage extends StatefulHookWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFoodRecommendation(context);
    List<FoodModel>? foods = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondary,
        title: const ReuseableText(
          text: 'Recommendations',
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
