// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/cart/cart_model.dart';
import '../../models/food/food_model.dart';
import '../../models/login/login_respose_model.dart';
import '../../models/order/order_request_model.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../repository/hooks/fatch_restaurant_byId.dart';
import '../../repository/hooks/fetch_defult_address.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/address_bottom_sheet.dart';
import '../../res/components/coustom_button.dart';
import '../../res/components/coustom_textformfield.dart';
import '../../res/components/phone_bottom_sheet.dart';
import '../../res/components/reuseable_text.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/cart/cart_view_model.dart';
import '../../view_models/controller/food/food_view_model.dart';
import '../../view_models/controller/login/login_view_model.dart';
import '../orders/orders_view.dart';
import '../restaurant/restaurant_view.dart';

class FoodScreen extends StatefulHookWidget {
  const FoodScreen({super.key, required this.foods});
  final FoodModel? foods;

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final PageController pageController = PageController();
  final TextEditingController _preferences = TextEditingController();
  final _controller = Get.put(FoodsController());

  @override
  void initState() {
    _controller.loadAdditives(widget.foods!.additives);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final LoginResponseModel? user;
    final cartController = Get.put(CartController());
    final loginController = Get.put(LoginController());
    user = loginController.getUserInfo();
    // _controller.loadAdditives(widget.foods.additives);
    final hookResult = useFetchRestaurantById(widget.foods!.restaurant);
    final RestaurantModel? restaurants = hookResult.data;
    // ! address
    var addressTrigger = box.read('defultAddress');
    final addressHookResult = useDefaultAddress(context);
    final address = addressHookResult.data;

    // !
    // print(restaurants!.id);

    // print(widget.foods.restaurant);
    // !
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.r),
          ),
          child: Stack(
            children: [
              SizedBox(
                height: 280.h,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) {
                    _controller.changePage(value);
                  },
                  itemCount: widget.foods!.imageUrl.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: kLightWhite,
                      child:
                          // Image.network(
                          //   widget.foods!.imageUrl[index],
                          //   fit: BoxFit.cover,
                          // )
                          CachedNetworkImage(
                        imageUrl: widget.foods!.imageUrl[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // ! image

              Positioned(
                bottom: 10.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.foods!.imageUrl.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.all(4.h),
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _controller.currentPage.value == index
                                ? kSecondary
                                : kGray,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // ! back
              Positioned(
                top: 70,
                left: 12.w,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    // Get.offAll(() => MainScreen());
                  },
                  child: Icon(
                    Ionicons.chevron_back_circle,
                    color: kPrimary,
                    size: 35.spMin,
                  ),
                ),
              ),
              // ! go to restaurant page
              Positioned(
                  bottom: 10.h,
                  right: 12.w,
                  child: CustomButton(
                    btnWidth: 110.w,
                    onTap: () {
                      // Get.delete(FoodsController());
                      // Get.delete<FoodsController>();
                      if (Get.isRegistered<FoodsController>() ||
                          Get.isPrepared<FoodsController>()) {
                        Get.delete<FoodsController>();
                      }
                      // Get.to(() => RestaurantScreen(
                      //       restaurants: hookResult.data,
                      //     ));
                      // Get.offAll(() => RestaurantScreen(
                      //       restaurants: hookResult.data,
                      //       address: address,
                      //     ));
                      if (user == null) {
                        Get.toNamed(RouteName.LoginScreen);
                      } else if (user.phoneVerification == false) {
                        showVerificationSheet(context);
                      } else if (addressTrigger == false) {
                        showAddressSheet(context);
                      } else {
                        Future.delayed(Duration.zero, () {
                          Get.to(() => RestaurantScreen(
                                restaurants: hookResult.data,
                                address: address,
                              ));
                        });
                      }
                    },
                    child: const Center(
                      child: ReuseableText(
                        text: 'Open Restaurant',
                        fontSize: 12,
                        textColor: kLightWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  // Handle other states if needed
                  ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReuseableText(
                    text: widget.foods!.title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textColor: kDark,
                  ),
                  Obx(
                    () => ReuseableText(
                      // text:
                      //     "\$ ${(widget.foods.price + _controller.additivesPrice) * _controller.count.value}",

                      text:
                          "\$ ${((widget.foods!.price + _controller.additivesPrice) * _controller.count.value).toStringAsFixed(2)}",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textColor: kPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              ReuseableText(
                text: widget.foods!.description,
                fontSize: 11,
                textAlign: TextAlign.justify,
                fontWeight: FontWeight.w400,
                textColor: kGray,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 18.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    widget.foods!.foodTags.length,
                    (index) {
                      final tag = widget.foods!.foodTags[index];
                      return Container(
                        margin: EdgeInsets.only(right: 5.w),
                        decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: ReuseableText(
                              text: tag,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              const ReuseableText(
                text: 'Additives and Toppings',
                fontSize: 18,
                textColor: kDark,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => Column(
                  children: List.generate(
                    _controller.additivesList.length,
                    (index) {
                      final additive = _controller.additivesList[index];

                      return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          activeColor: kPrimary,
                          tristate: false,
                          value: additive
                              .isChecked.value, // Adjust based on your logic
                          onChanged: (bool? value) {
                            additive.toggleChecked();
                            _controller.getTotalPrice();
                            _controller.getCartAditives();
                            // print(_controller.getCartAditives());
                          },
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReuseableText(
                                  text: additive.title.toString(),
                                  fontSize: 15,
                                  textColor: kDark,
                                  fontWeight: FontWeight.w400,
                                ),
                                ReuseableText(
                                  text: "\$ ${additive.price.toString()}",
                                  fontSize: 15,
                                  textColor: kPrimary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ]));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const ReuseableText(
                  text: 'Quantity',
                  fontSize: 18,
                  textColor: kDark,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 5.w,
                ),
                //!  Count
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.increment();
                      },
                      child: const Icon(AntDesign.pluscircle),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Obx(
                          () => ReuseableText(
                            text: _controller.count.value.toString(),
                            fontSize: 14,
                            textColor: kDark,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        _controller.decrement();
                      },
                      child: const Icon(AntDesign.minuscircle),
                    ),
                  ],
                )
              ]),
              SizedBox(
                height: 20.h,
              ),
              const ReuseableText(
                text: 'Preferences',
                fontSize: 18,
                textColor: kDark,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 70.h,
                child: CustomTextFormField(
                  controller: _preferences,
                  maxLines: 3,
                  hintText: "Add a note with your Preferences",
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              // ! order place
              Container(
                height: 40.h,
                decoration: BoxDecoration(
                    color: kPrimary, borderRadius: BorderRadius.circular(19.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: GestureDetector(
                        onTap: () {
                          if (user == null) {
                            Get.toNamed(RouteName.LoginScreen);
                          } else if (user.phoneVerification == false) {
                            showVerificationSheet(context);
                          } else if (addressTrigger == false) {
                            showAddressSheet(context);
                          } else {
                            // ! total prices
                            double price = (widget.foods!.price +
                                    _controller.additivesPrice) *
                                _controller.count.value;
                            // ! Order Item from the order model
                            OrderItem item = OrderItem(
                              foodId: widget.foods!.id,
                              quantity: _controller.count.value,
                              price: price,
                              additives: _controller.getCartAditives(),
                              instruction: _preferences.text,
                            );

                            // ! Go To order page
                            // print('=============: $address');
                            Get.to(
                              () => OrdersScreen(
                                  restaurant: restaurants,
                                  food: widget.foods,
                                  item: item,
                                  address: address),
                              duration: const Duration(milliseconds: 900),
                              transition: Transition.leftToRightWithFade,
                            );
                            // print(user.phoneVerification);
                            // print('Place Order');
                          }
                        },
                        child: const ReuseableText(
                          text: 'Place Order',
                          fontSize: 18,
                          textColor: kLightWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // ! add item in to cart
                    GestureDetector(
                      onTap: () {
                        double price =
                            (widget.foods!.price + _controller.additivesPrice) *
                                _controller.count.value;

                        var data = CartModel(
                            productId: widget.foods!.id,
                            additives: _controller.getCartAditives(),
                            quantity: _controller.count.value,
                            totalPrice: price);

                        String cart = cartModelToJson(data);
                        cartController.addToCart(cart);
                      },
                      child: CircleAvatar(
                        backgroundColor: kSecondary,
                        radius: 20.r,
                        child: const Icon(
                          Ionicons.cart,
                          color: kPrimary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        )
      ],
    ));
  }
}
