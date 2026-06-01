import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'category_shimer.dart';
import 'foodslist_shimer.dart';
import 'nearby_shimer.dart';

/// Composite skeleton placeholder for the entire home screen,
/// shown while we have no data to render yet.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  Widget _heading({double width = 140}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: [
        _heading(width: 140),
        const CategoriesShimmer(),
        _heading(width: 170),
        const NearbyShimmer(),
        _heading(width: 180),
        SizedBox(
          height: 220.h,
          child: const FoodListShimmer(),
        ),
      ],
    );
  }
}
