import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/rating/rating_request_model.dart';
import '../../../models/restaurant/restaurant_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/coustom_button.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../view_models/controller/rating/rating_view_model.dart';

class RateRestaurantPage extends StatefulWidget {
  final RestaurantModel? restaurant;

  const RateRestaurantPage({
    super.key,
    this.restaurant,
  });

  @override
  State<RateRestaurantPage> createState() => _RateRestaurantPageState();
}

class _RateRestaurantPageState extends State<RateRestaurantPage> {
  final ratingController = Get.put(RatingController());
  @override
  void initState() {
    super.initState();
    ratingController.checkRating(widget.restaurant!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: ReuseableText(
          text: 'Rate: ${widget.restaurant!.title}',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
          textColor: kGray,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                if (ratingController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (ratingController.hasRated.value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ReuseableText(
                        text: 'You rated this restaurant',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        textColor: kGray,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      RatingBarIndicator(
                        rating: ratingController.userRating.value,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 60.h,
                        direction: Axis.horizontal,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ReuseableText(
                        text: 'Rate this restaurant by tap on the stars',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        textColor: kGray,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        // color: Colors.red,
                        height: 90.h,
                        width: double.infinity,
                        child: Center(
                          child: RatingBar.builder(
                            initialRating: 3,
                            itemSize: 60.w,
                            glowColor: kPrimary,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 3.w),
                            itemBuilder: (context, _) => Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber,
                              size: 20.spMin,
                            ),
                            onRatingUpdate: (rating) {
                              ratingController.userRating.value = rating;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        onTap: () {
                          RatingResquestModel rating = RatingResquestModel(
                            product: widget.restaurant!.id,
                            rating: ratingController.userRating.value,
                            ratingType: 'Restaurant',
                          );
                          var data = ratingResquestModelToJson(rating);
                          ratingController.submitRating(
                              widget.restaurant!.id, data);
                        },
                        btnColor: kPrimary,
                        btnHeight: 40.h,
                        btnWidth: width,
                        child: const Center(
                            child: ReuseableText(
                          text: 'Submit Rating',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          textColor: Colors.white,
                        )),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
