// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../models/address/address_respose_model.dart';
// import '../../../models/restaurant/restaurant_model.dart';
// import '../../../repository/hooks/fatch_restaurant.dart';
// import '../../../repository/hooks/fetch_defult_address.dart';
// import '../../../res/components/shimer/nearby_shimer.dart';
// import '../../restaurant/restaurant_view.dart';
// import 'restrurant_widget.dart';

// class NearByRestaurant extends HookWidget {
//   const NearByRestaurant({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final hookResult = useFetchRestaurant(context);
//     List<RestaurantModel>? restaurants = hookResult.data;
//     final error = hookResult.error;
//     final isLoading = hookResult.isLoading;
//     print(restaurants);
//     // final box = GetStorage();
//     // ! address
//     // var addressTrigger = box.read('defultAddress');
//     final addressHookResult = useDefaultAddress(context);
//     final AddressResponseModel? address = addressHookResult.data;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SingleChildScrollView(
//             child: isLoading
//                 ? const NearbyShimmer()
//                 : (error != null
//                     ? Center(child: Text('Error: ${error.toString()}'))
//                     : Container(
//                         height: 205.h,
//                         padding: EdgeInsets.only(left: 12.w, top: 10.h),
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: restaurants!.length,
//                           itemBuilder: (context, index) {
//                             var restaurant = restaurants[index];
//                             return RestaurantWidget(
//                               onTap: () {
//                                 Get.to(() => RestaurantScreen(
//                                       restaurants: restaurant,
//                                       address: address,
//                                     ));
//                               },
//                               image: restaurant.imageUrl,
//                               logo: restaurant.logoUrl,
//                               title: restaurant.title,
//                               time: restaurant.time,
//                               rating: restaurant
//                                   .rating, // Replace with actual rating
//                             );
//                           },
//                         ),
//                       ))),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/address/address_respose_model.dart';
import '../../../models/login/login_respose_model.dart';
import '../../../models/restaurant/restaurant_model.dart';
import '../../../repository/hooks/fatch_restaurant.dart';
import '../../../repository/hooks/fetch_defult_address.dart';
import '../../../res/components/address_bottom_sheet.dart';
import '../../../res/components/phone_bottom_sheet.dart';
import '../../../res/components/shimer/nearby_shimer.dart';
import '../../../res/routes/routes_name.dart';
// ignore: unused_import
import '../../../view_models/controller/login/login_view_model.dart';
import '../../restaurant/restaurant_view.dart';
import 'restrurant_widget.dart';

class NearByRestaurant extends HookWidget {
  const NearByRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    // final userInfoController = Get.put(UserInformation());
    final LoginResponseModel? user;
    final loginController = Get.put(LoginController());
    user = loginController.getUserInfo();
    final hookResult = useFetchRestaurant(context);
    List<RestaurantModel>? restaurants = hookResult.data;
    final error = hookResult.error;
    final isLoading = hookResult.isLoading;
    final box = GetStorage();
    // ! address
    // var addressTrigger = box.read('defultAddress');
    final addressHookResult = useDefaultAddress(context);
    final AddressResponseModel? address = addressHookResult.data;

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
                          itemCount: restaurants!.length,
                          itemBuilder: (context, index) {
                            var restaurant = restaurants[index];
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
                                        address: address,
                                      ));
                                }
                              },
                              image: restaurant.imageUrl,
                              logo: restaurant.logoUrl,
                              title: restaurant.title,
                              time: restaurant.time,
                              rating: restaurant
                                  .rating, // Replace with actual rating
                            );
                          },
                        ),
                      ))),
      ],
    );
  }
}
