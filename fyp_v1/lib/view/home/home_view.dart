// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/address/address_respose_model.dart';
import '../../models/login/login_respose_model.dart';
import '../../repository/hooks/fatch_all_address.dart';
import '../../res/components/address_bottom_sheet.dart';
import '../../res/components/coustom_appBar.dart';
import '../../res/components/heading.dart';
import '../../res/components/phone_bottom_sheet.dart';
import '../../res/components/reuseable_text.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/cart/cart_view_model.dart';
import '../../view_models/controller/category/category_view_model.dart';
import '../../view_models/controller/login/login_view_model.dart';
import '../../view_models/controller/user/user_view_model.dart';
import '../category/widget/category_food_list.dart';
import '../category/widget/category_list.dart';
import 'widget/foods_list.dart';
import 'widget/nearby_restaurents.dart';

class HomeScreen extends StatefulHookWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cartController = Get.put(CartController());
  final userInfoController = Get.put(UserInformation());
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    final cartController = Get.put(CartController());
    final userInfoController = Get.put(UserInformation());
    userInfoController.fetchUserData();
    cartController.fetchCartCount();
    LoginResponseModel? user;
    final controller = Get.put(LoginController());

    // var addressTrigger = box.read('defultAddress');
    // if (addressTrigger == false) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showAddressSheet(context);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _categoryController = Get.put(CategoryController());
    final loginController = Get.put(LoginController());
    loginController.getUserInfo();
    final addrresses = useFetchAddress();
    final List<AddressResponseModel> addresses = addrresses.data ?? [];
    LoginResponseModel? user;
    final controller = Get.put(LoginController());
    final cartController = Get.put(CartController());
    final userInfoController = Get.put(UserInformation());
    userInfoController.fetchUserData();
    cartController.fetchCartCount();
    bool _isAddressSheetShown = false; // Flag to prevent multiple calls

    String? token = box.read('token');
    // print('$token : 222');
    if (token != null) {
      user = controller.getUserInfo();

      // print(user!.email);
      // print('$token : 333');
    }

    // print(token);
    // print('home page cart count:${cartController.count}');
    return Scaffold(
        appBar: const CustomAppBar(),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          children: [
            Heading(
              text: 'All Categories',
              onTap: () {
                Get.toNamed(RouteName.allCategoriesScreen);
              },
            ),
            const CategoryList(),
            // !
            Obx(() => _categoryController.categoryValue == ''
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading(
                        text: 'Nearby Restaurant',
                        onTap: () {
                          var addressTrigger = box.read('defultAddress');
                          if (user == null) {
                            Get.toNamed(RouteName.LoginScreen);
                          } else if (user.phoneVerification == false) {
                            showVerificationSheet(context);
                          } else if (addressTrigger == false) {
                            showAddressSheet(context);
                          } else {
                            Get.toNamed(RouteName.allNearByRestaurant);
                          }
                        },
                      ),
                      const NearByRestaurant(),
                      Heading(
                        text: 'Try Something New',
                        onTap: () {
                          Get.toNamed(RouteName.recommendationPage);
                        },
                      ),
                      const FoodsList(),
                      Heading(
                        text: 'Food Closer to you',
                        onTap: () {
                          Get.toNamed(RouteName.allFastestFoods);
                        },
                      ),
                      const FoodsList(),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child:
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     ReuseableText(
                        //       fontSize: 16.spMin,
                        //       fontWeight: FontWeight.bold,
                        //       text: 'Explore ${_categoryController.title} category',
                        //     ),
                        //     const CategoryFoodsList()
                        //   ],
                        // ),
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseableText(
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.bold,
                          text: 'Explore ${_categoryController.title} category',
                        ),
                        const CategoryFoodsList(), // Shows foods from the selected category
                      ],
                    ),
                  ))
          ],
        ));
  }
}
