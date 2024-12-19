import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/utils/uid.dart';
import 'widget/food_tiles.dart';

class FoodsList extends StatelessWidget {
  const FoodsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kSecondary,
        title: ReuseableText(
          text: 'Foods List',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return FoodTile(
              food: food,
            );
          },
        ),
      ),
    );
  }
}
