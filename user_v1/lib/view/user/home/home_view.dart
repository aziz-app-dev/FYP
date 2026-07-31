// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../res/res_imports.dart';

import '../../../models/login/login_respose_model.dart';
import '../../../repository/hooks/fetch_home_data.dart';
import '../../../view_models/controller/cart/cart_view_model.dart';
import '../../../view_models/controller/category/category_view_model.dart';
import '../../../view_models/controller/login/login_view_model.dart';
import '../../../view_models/controller/user/user_view_model.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final _categoryController = Get.put(CategoryController());
    final loginController = Get.put(LoginController());
    loginController.getUserInfo();

    LoginResponseModel? user;
    final controller = Get.put(LoginController());
    final cartCtrl = Get.put(CartController());
    final userInfoCtrl = Get.put(UserInformation());

    String? token = box.read('token');
    if (token != null) {
      user = controller.getUserInfo();
    }

    // Single API call for all home data (with local cache).
    final homeResult = useFetchHomeData(context);
    final homeData = homeResult.data;
    final isLoading = homeResult.isLoading;
    final error = homeResult.error;
    final isFromCache = homeResult.isFromCache;

    // Guard to ensure the address sheet shows only once per mount
    final addressSheetShown = useRef<bool>(false);

    // Update cart count and user data from home API response
    // Deferred to post-frame to avoid triggering Obx rebuilds during build
    if (homeData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cartCtrl.setCount = homeData.cartCount;
        if (homeData.user != null) {
          userInfoCtrl.user = homeData.user;
          userInfoCtrl.imageUrl.value = homeData.user!.profile;
        }

        // Show address sheet once if user is logged in but has no default address
        final isLoggedIn = token != null && homeData.user != null;
        if (isLoggedIn &&
            homeData.defaultAddress == null &&
            !addressSheetShown.value &&
            context.mounted) {
          addressSheetShown.value = true;
          box.write('defultAddress', false);
          showAddressSheet(context);
        }
      });
    }

    // No data + still fetching -> skeleton placeholder.
    if (homeData == null && isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(),
        body: HomeSkeleton(),
      );
    }

    // No data + hard error (server off, no cache) -> reusable error widget
    // with the Retry button wired to refetch.
    if (homeData == null && error != null) {
      return GeneralExceptionWidget(
        subtitle: error.toString().replaceFirst('Exception: ', ''),
        onRetry: () => homeResult.refetch?.call(),
      );
    }

    return Scaffold(
        appBar: const CustomAppBar(),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          children: [
            // Offline banner shown while the user is seeing cached data.
            if (isFromCache && error != null)
              Container(
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_off_rounded,
                        size: 16.spMin, color: kPrimary),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ReuseableText(
                        text: 'Showing saved data · server unreachable',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        textColor: kPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => homeResult.refetch?.call(),
                      child: ReuseableText(
                        text: 'Retry',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        textColor: kPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            Heading(
              text: 'All Categories',
              onTap: () {
                Get.toNamed(RouteName.allCategoriesScreen);
              },
            ),
            CategoryList(
              categories: homeData?.categories,
              isLoading: isLoading,
              error: error,
            ),
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
                      NearByRestaurant(
                        restaurants: homeData?.restaurants,
                        isLoading: isLoading,
                        error: error,
                        defaultAddress: homeData?.defaultAddress,
                      ),
                      Heading(
                        text: 'Try Something New',
                        onTap: () {
                          Get.toNamed(RouteName.recommendationPage);
                        },
                      ),
                      FoodsList(
                        foods: homeData?.foods,
                        isLoading: isLoading,
                        error: error,
                      ),
                      Heading(
                        text: 'Food Closer to you',
                        onTap: () {
                          Get.toNamed(RouteName.allFastestFoods);
                        },
                      ),
                      FoodsList(
                        foods: homeData?.foods,
                        isLoading: isLoading,
                        error: error,
                      ),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseableText(
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.bold,
                          text:
                              'Explore ${_categoryController.title} category',
                        ),
                        const CategoryFoodsList(),
                      ],
                    ),
                  ))
          ],
        ));
  }
}
