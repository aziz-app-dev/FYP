// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/address/address_respose_model.dart';
import '../../../../models/login/login_respose_model.dart';
import '../../../../models/restaurant/restaurant_model.dart';
import '../../../../res/res_imports.dart';

import '../../../../view_models/controller/login/login_view_model.dart';
import '../../restaurant/restaurant_view.dart';

class RestaurantTile extends StatelessWidget {
  final RestaurantModel restaurant;
  final AddressResponseModel address;
  const RestaurantTile(
      {super.key, required this.restaurant, required this.address});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final LoginResponseModel? user;
    final loginController = Get.put(LoginController());
    user = loginController.getUserInfo();
    var addressTrigger = box.read('defultAddress');
    return GestureDetector(
      onTap: () {
        if (user == null) {
          Get.toNamed(RouteName.LoginScreen);
        } else if (user.phoneVerification == false) {
          showVerificationSheet(context);
        } else if (addressTrigger == false) {
          showAddressSheet(context);
        } else {
          Future.delayed(Duration.zero, () {
            Get.to(() => RestaurantScreen(
                  restaurants: restaurant,
                  address: address,
                ));
          });
        }
        // Get.to(() => RestaurantScreen(
        //       restaurants: restaurant,
        //       address: address, // Pass the restaurant in a list
        //     ));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 70.h,
            // width: 300.w, // Adjust the width as needed
            decoration: BoxDecoration(
              color: kOffWhite,
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 70.w,
                          height: 70.h,
                          child: Image.network(
                            restaurant.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
                            color: kGray.withOpacity(0.7),
                            height: 16.h,
                            width: 70.w,
                            child: RatingBarIndicator(
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: kSecondary,
                              ),
                              itemSize: 12.spMin,
                              itemCount: 5,
                              rating: (restaurant.rating).toDouble(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseableText(
                        text: restaurant.title,
                        fontSize: 11,
                        textColor: kDark,
                        fontWeight: FontWeight.w400,
                      ),
                      ReuseableText(
                        text: "Delivery time: ${restaurant.time}",
                        fontSize: 11,
                        textColor: kDark,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        width: 230.w,
                        child: ReuseableText(
                          text: restaurant.coords.address,
                          fontSize: 7,
                          textColor: kDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5.w,
            top: 6.h,
            child: Container(
              height: 25.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: restaurant.isAvailable ? kPrimary : kSecondaryLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: ReuseableText(
                  text: restaurant.isAvailable ? 'Open' : 'Close',
                  fontSize: 12,
                  textColor: kLightWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
