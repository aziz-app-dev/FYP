import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/res_imports.dart';

class RestaurantWidget extends StatelessWidget {
  final String image;
  final String logo;
  final String title;
  final String time;
  final double rating;
  final VoidCallback? onTap;

  const RestaurantWidget({
    super.key,
    required this.image,
    required this.logo,
    required this.title,
    required this.time,
    required this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: 250,
          height: 195,
          // width: 250.w,
          // height: 195.h,
          decoration: BoxDecoration(
            color: kLightWhite,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        height: 122.h,
                        width: 259.w,
                        child: Image.network(
                          image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      // right: 10.w,
                      // top: 10.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          color: kLightWhite,
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Image.network(
                                logo,
                                fit: BoxFit.cover,
                                width: 20,
                                height: 20,
                                // width: 20.w,
                                // height: 20.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReuseableText(
                      text: title,
                      textColor: kDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ReuseableText(
                          text: 'Deliver To',
                          textColor: kDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        ReuseableText(
                          text: time,
                          textColor: kDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          itemBuilder: (context, index) {
                            return const Icon(
                              Icons.star,
                              color: kPrimary,
                            );
                          },
                          itemCount: 5,
                          itemSize: 15.h,
                          rating: rating,
                          // rating: 3,
                        ),
                        SizedBox(height: 10.w),
                        ReuseableText(
                          text: ' $rating reviews and ratings',
                          textColor: kDark,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
