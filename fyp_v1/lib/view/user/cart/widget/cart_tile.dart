// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../../../res/res_imports.dart';
import '../../../../models/cart/cart_response_model.dart';
import '../../../../models/food/food_model.dart';
import '../../../../repository/hooks/fetch_food_by_id.dart';
import '../../../../view_models/controller/cart/cart_view_model.dart';
import '../../food/foods_view.dart';

class CartTile extends HookWidget {
  final CartResponseModel cart;
  final Function()? refresh;
  // final FoodModel food;
  const CartTile({
    super.key,
    required this.cart,
    this.refresh,
    // required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final foodById = useFetchFoodById(cart.productId.id);
    final FoodModel? food = foodById.data;
    final controller = Get.put(CartController());
    // print("=======:${food}");

    return GestureDetector(
      onTap: () {
        Future.delayed(Duration.zero, () {
          Get.to(() => FoodScreen(foods: food));
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 70.w,
                          height: 70.h,
                          child: Image.network(
                            cart.productId.imageUrl[0], // Placeholder image
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
                              rating: cart.productId.rating,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReuseableText(
                            text: cart.productId.title,
                            fontSize: 15,
                            textColor: kDark,
                            fontWeight: FontWeight.w500,
                          ),
                          if (cart.additives.isNotEmpty)
                            SizedBox(
                              height: 18.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cart.additives.length,
                                itemBuilder: (context, i) {
                                  var additive = cart.additives[i];
                                  return Container(
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                      color: kSecondary,
                                      borderRadius: BorderRadius.circular(9.r),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: ReuseableText(
                                          text: additive,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
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
                color: kPrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: ReuseableText(
                  text: '\$ ${cart.totalPrice.toStringAsFixed(2)}',
                  fontSize: 12,
                  textColor: kLightWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 75.w,
            top: 6.h,
            child: GestureDetector(
              onTap: () {
                controller.removeToCart(cart.id, refresh!);
              },
              child: Container(
                height: 20.h,
                width: 20.w,
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    MaterialCommunityIcons.trash_can,
                    size: 15.spMin,
                    color: kLightWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
