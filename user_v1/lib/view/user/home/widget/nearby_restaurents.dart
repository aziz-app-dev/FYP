import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../models/address/address_respose_model.dart';
import '../../../../models/login/login_respose_model.dart';
import '../../../../models/restaurant/restaurant_model.dart';
import '../../../../res/res_imports.dart';
// ignore: unused_import
import '../../../../view_models/controller/login/login_view_model.dart';
import '../../restaurant/restaurant_view.dart';
import 'restrurant_widget.dart';

class NearByRestaurant extends StatelessWidget {
  final List<RestaurantModel>? restaurants;
  final bool isLoading;
  final Exception? error;
  final AddressResponseModel? defaultAddress;

  const NearByRestaurant({
    super.key,
    required this.restaurants,
    required this.isLoading,
    this.error,
    this.defaultAddress,
  });

  @override
  Widget build(BuildContext context) {
    final LoginResponseModel? user;
    final loginController = Get.put(LoginController());
    user = loginController.getUserInfo();
    final box = GetStorage();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
            child: isLoading
                ? const NearbyShimmer()
                : (error != null
                    ? Center(child: Text('Error: ${error.toString()}'))
                    : Container(
                        height: 205.h,
                        padding: EdgeInsets.only(left: 12.w, top: 10.h),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restaurants?.length ?? 0,
                          itemBuilder: (context, index) {
                            var restaurant = restaurants![index];
                            return RestaurantWidget(
                              onTap: () {
                                var addressTrigger = box.read('defultAddress');
                                if (user == null) {
                                  Get.toNamed(RouteName.LoginScreen);
                                } else if (user.phoneVerification == false) {
                                  showVerificationSheet(context);
                                } else if (addressTrigger == false) {
                                  showAddressSheet(context);
                                } else {
                                  Get.to(() => RestaurantScreen(
                                        restaurants: restaurant,
                                        address: defaultAddress,
                                      ));
                                }
                              },
                              image: restaurant.imageUrl,
                              logo: restaurant.logoUrl,
                              title: restaurant.title,
                              time: restaurant.time,
                              rating: restaurant.rating,
                            );
                          },
                        ),
                      ))),
      ],
    );
  }
}
