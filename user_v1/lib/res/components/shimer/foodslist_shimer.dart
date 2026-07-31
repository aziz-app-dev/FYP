import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/app_color.dart';
import 'shimer_widget.dart';

class FoodListShimmer extends StatelessWidget {
  const FoodListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10),
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 6,
        itemBuilder: (context, index) {
          return ShimerWidget(
            shimerWidth: 50.w,
            shimerHeight: 50.h,
            shimerRadius: 12.r,
          );
        },
      ),
    );
  }
}
