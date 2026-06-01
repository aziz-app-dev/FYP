import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shimer_widget.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10),
      height: 75.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                  width: 70.w,
                  height: 60.h,
                  padding: const EdgeInsets.only(right: 12, top: 8),
                  child: ShimerWidget(
                    shimerWidth: 70.w,
                    shimerHeight: 60.h,
                    shimerRadius: 12.r,
                  )),
            ],
          );
        },
      ),
    );
  }
}
