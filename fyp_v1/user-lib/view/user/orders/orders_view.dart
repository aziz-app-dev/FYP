import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/res_imports.dart';

import '../../../models/address/address_respose_model.dart';
import '../../../models/distance_time.dart';
import '../../../models/food/food_model.dart';
import '../../../models/order/order_request_model.dart';
import '../../../models/restaurant/restaurant_model.dart';
import '../../../view_models/controller/orders/order_view_model.dart';
import '../../../view_models/services/distance.dart';
import 'widget/order_success_dialog.dart';
import 'widget/order_tile.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen(
      {super.key,
      this.restaurant,
      required this.food,
      required this.item,
      this.address});
  final RestaurantModel? restaurant;
  final FoodModel? food;
  final OrderItem item;
  final AddressResponseModel? address;
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    DistanceTime data = Distance().calculateDistanceTimePrice(
        widget.restaurant!.coords.latitude,
        widget.restaurant!.coords.longitude,
        widget.address!.latitude,
        widget.address!.longitude,
        10,
        2);
    double totalGrand = widget.item.price + data.price;
    // print(widget.item.additives);
    // print(widget.address!.city);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimary,
        title: const ReuseableText(
          text: 'Complete Ordering',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          textColor: kLightWhite,
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              // ! food tile
              OrderTile(food: widget.food),
              // ! order details container
              Container(
                width: width,
                height: height / 3.4,
                decoration: BoxDecoration(
                  color: kOffWhite,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReuseableText(
                            text: widget.restaurant!.title,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            textColor: kGray,
                          ),
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: kPrimary,
                            backgroundImage:
                                NetworkImage(widget.restaurant!.logoUrl),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: 'Business Hour',
                          second: widget.restaurant!.time),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: 'Distance from Restaurant',
                          second: '${data.distance.toStringAsFixed(2)} km'),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: 'Price from Restaurant',
                          second: '\$ ${data.price.toStringAsFixed(2)}'),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: 'Order total',
                          second: '\$ ${widget.item.price.toStringAsFixed(2)}'),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: 'Grands total',
                          second: '\$ ${totalGrand.toStringAsFixed(2)}'),
                      SizedBox(
                        height: 5.h,
                      ),
                      const RowText(
                        first: 'Payment Method',
                        second: 'Cash on delivery',
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      const ReuseableText(
                        text: 'Additives',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        textColor: kGray,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 18.h,
                        width: width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.item.additives.length,
                          itemBuilder: (context, i) {
                            String additive = widget.item.additives[i];
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
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                final busy = controller.isLoading;
                return AbsorbPointer(
                  absorbing: busy,
                  child: CustomButton(
                    btnColor: busy ? kSecondary : kPrimary,
                    btnHeight: 40.h,
                    btnWidth: width,
                    radius: 9.r,
                    onTap: () async {
                      final order = OrderRequestModel(
                        orderItems: [widget.item],
                        orderTotal: widget.item.price,
                        deliveryFee: data.price,
                        grandTotal: totalGrand,
                        deliveryAddress: widget.address!.id,
                        restaurantAddress: widget.restaurant!.coords.address,
                        restaurantCoords: [
                          widget.restaurant!.coords.latitude,
                          widget.restaurant!.coords.longitude
                        ],
                        recipientCoords: [
                          widget.address!.latitude,
                          widget.address!.longitude
                        ],
                        restaurantId: widget.restaurant!.id,
                        orderStatus: 'Pending',
                        paymentMethod: 'Cash',
                        paymentStatus: 'Pending',
                        rating: 3.0,
                      );

                      final orderId = await controller.createOrder(
                          orderRequestModelToJson(order));
                      if (orderId == null) return;
                      await showOrderSuccessDialog(
                        orderId: orderId,
                        itemCount: 1,
                        grandTotal: totalGrand,
                      );
                    },
                    child: Center(
                      child: busy
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(kPrimary),
                              ),
                            )
                          : const ReuseableText(
                              text: 'Process Your Order',
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  final String first;
  final String second;
  const RowText({
    super.key,
    required this.first,
    required this.second,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReuseableText(
          text: first,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          textColor: kGray,
        ),
        ReuseableText(
          text: second,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.right,
          textColor: kGray,
        ),
      ],
    );
  }
}
