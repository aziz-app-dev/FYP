import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/routes/routes_name.dart';
import '../../view models/controllers/food_crud_view_model.dart';
import '../../view models/controllers/vendor_restaurant_view_model.dart';
import 'food_details_view.dart';
import 'food_edit_view.dart';
import 'widget/food_tiles.dart';

class FoodsList extends StatefulWidget {
  const FoodsList({super.key});

  @override
  State<FoodsList> createState() => _FoodsListState();
}

class _FoodsListState extends State<FoodsList> {
  final _crud = Get.put(FoodCrudController());
  final _vendor = Get.put(VendorRestaurantController());

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    // Make sure we know the vendor's restaurant
    if (_vendor.activeId == null) {
      await _vendor.fetchMine();
    }
    final id = _vendor.activeId;
    if (id != null && id.isNotEmpty) {
      await _crud.fetchByRestaurant(id);
    }
  }

  Future<bool> _confirm(String title, String subtitle) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: kWhite,
        title: ReuseableText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          textColor: kDark,
        ),
        content: ReuseableText(
          text: subtitle,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          textColor: kGray,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const ReuseableText(
              text: 'Cancel',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              textColor: kGray,
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const ReuseableText(
              text: 'Yes',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              textColor: kRed,
            ),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    // Guard — vendor must have a Verified restaurant.
    final noRestaurant =
        _vendor.activeId == null || _vendor.activeId!.isEmpty;
    if (noRestaurant || !_vendor.isVerified) {
      final status = _vendor.verificationStatus;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kSecondary,
          leading: const AppBackButton(),
          title: ReuseableText(
            text: 'My Foods',
            fontSize: 16.spMin,
            fontWeight: FontWeight.w600,
            textColor: kWhite,
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  noRestaurant
                      ? Icons.storefront_outlined
                      : (status == 'Rejected'
                          ? Icons.cancel_rounded
                          : Icons.hourglass_top_rounded),
                  size: 72.spMin,
                  color: kGray,
                ),
                SizedBox(height: 12.h),
                ReuseableText(
                  text: noRestaurant
                      ? 'No restaurant yet'
                      : status == 'Rejected'
                          ? 'Application rejected'
                          : 'Waiting for approval',
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.w700,
                  textColor: kDark,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                ReuseableText(
                  text: noRestaurant
                      ? 'Submit your restaurant application first.'
                      : status == 'Rejected'
                          ? 'You can re-apply from the Restaurant screen.'
                          : 'An admin needs to approve your restaurant before you can add foods.',
                  fontSize: 12.spMin,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18.h),
                GestureDetector(
                  onTap: () =>
                      Get.offAllNamed(RouteName.restaurantScreen),
                  child: Container(
                    height: 44.h,
                    width: 200.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ReuseableText(
                      text: 'Go to Restaurant',
                      fontSize: 13.spMin,
                      fontWeight: FontWeight.w600,
                      textColor: kLightWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kSecondary,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'My Foods',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhite),
            onPressed: _loadFoods,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimary,
        icon: const Icon(Icons.add, color: kWhite),
        label: ReuseableText(
          text: 'Add Food',
          fontSize: 13.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
        onPressed: () async {
          await Get.toNamed(RouteName.AddFoodsScreen);
          _loadFoods();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _loadFoods,
        child: Container(
          color: kWhite,
          child: Obx(() {
            if (_crud.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: kPrimary),
              );
            }
            final foods = _crud.foods;
            if (foods.isEmpty) {
              return ListView(
                // keep scrollable for pull-to-refresh
                children: [
                  SizedBox(height: 200.h),
                  Center(
                    child: ReuseableText(
                      text: 'No foods yet. Tap "Add Food" to get started.',
                      fontSize: 13.spMin,
                      fontWeight: FontWeight.w500,
                      textColor: kGray,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 100.h, top: 6.h),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return FoodTile(
                  food: food,
                  onTap: () async {
                    await Get.to(
                      () => FoodDetailsScreen(food: food),
                      transition: Transition.rightToLeft,
                    );
                    _loadFoods(); // refresh in case edit happened
                  },
                  onEdit: () async {
                    await Get.to(
                      () => FoodEditScreen(food: food),
                      transition: Transition.rightToLeft,
                    );
                    _loadFoods();
                  },
                  onToggle: () => _crud.toggleAvailability(food.id),
                  onDelete: () async {
                    final ok = await _confirm(
                      'Delete food?',
                      'Are you sure you want to delete "${food.title}"?',
                    );
                    if (ok) _crud.deleteFood(food.id);
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
