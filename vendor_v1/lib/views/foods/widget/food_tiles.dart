import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({
    super.key,
    required this.food,
  });

  final Map<String, dynamic> food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w.h, vertical: 6.h),
      child: Container(
        height: 65.h,
        decoration: BoxDecoration(
          color: kOffWhite,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 6.w,
                  ),
                  child: SizedBox(
                    width: 62.w,
                    height: 62.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child:
                          Image.network(food['imageUrl'][0], fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseableText(
                        text: food['title'],
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w500,
                      ),
                      ReuseableText(
                        text: 'Delivery time: ${food['time']}',
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w500,
                        textColor: kGray,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          height: 18.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: food['additives'].length,
                            itemBuilder: (context, index) {
                              String title = food['additives'][index]['title'];

                              return Container(
                                margin: EdgeInsets.only(right: 5.w),
                                decoration: BoxDecoration(
                                  color: kSecondaryLight,
                                  borderRadius: BorderRadius.circular(9.r),
                                ),
                                child: Center(
                                  child: ReuseableText(
                                    text: title,
                                    fontSize: 8.spMin,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                right: 5.w,
                top: 5.h,
                child: Container(
                  height: 19.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: ReuseableText(
                      text: "\$${food['price'].toStringAsFixed(2)}",
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w500,
                      textColor: kLightWhite,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
