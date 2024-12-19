// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/order/clint_orders_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../view_models/controller/cart/cart_view_model.dart';
import '../../../view_models/controller/food/food_view_model.dart';
import '../../../view_models/controller/orders/order_view_model.dart';

class ClintOrderTile extends StatelessWidget {
  final OrderItem food;
  final String orderId;
  final Function()? refresh;

  const ClintOrderTile(
      {super.key, required this.food, required this.orderId, this.refresh});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final _controller = Get.put(FoodsController());
    final orderController = Get.put(OrderController());
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8.h),
          height: 80.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kOffWhite,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 70.w,
                        height: 70.h,
                        child: Image.network(
                          food.foodId.imageUrl[0], // Placeholder image
                          // food.imageUrl.isNotEmpty == true
                          //     ? food.imageUrl[0]
                          //     : 'https://via.placeholder.com/70', // Placeholder image
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
                            rating: food.foodId.rating,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseableText(
                        text: food.foodId.title,
                        fontSize: 15,
                        textColor: kDark,
                        fontWeight: FontWeight.w500,
                      ),
                      ReuseableText(
                        text: "Quantity: ${food.quantity}",
                        fontSize: 13,
                        textColor: kDark,
                        fontWeight: FontWeight.w400,
                      ),
                      if (food.additives.isNotEmpty)
                        SizedBox(
                          height: 18.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: food.additives.length,
                            itemBuilder: (context, i) {
                              var additive = food.additives[i];
                              return Container(
                                margin: EdgeInsets.only(right: 5.w),
                                decoration: BoxDecoration(
                                  color: kSecondaryLight,
                                  borderRadius: BorderRadius.circular(9.r),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(2.h),
                                    child: ReuseableText(
                                      text: additive,
                                      // text: 'additive',
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
                text: '\$ ${food.price.toStringAsFixed(2)}',
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
              orderController.cancelOrder(orderId, refresh!);
              // var data = CartModel(
              //     productId: food.id,
              //     additives: _controller.getCartAditives(),
              //     quantity: 1,
              //     totalPrice: food.price);
              // String cart = cartModelToJson(data);
              // controller.addToCart(cart);
            },
            child: Container(
              height: 20.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: kSecondary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.cancel,
                  size: 15.spMin,
                  color: kLightWhite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
