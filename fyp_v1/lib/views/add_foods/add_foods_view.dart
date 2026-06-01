import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widgets/additives_info.dart';
import 'widgets/food_info.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/routes/routes_name.dart';
import '../../common/utils/utils.dart';
import '../../view models/controllers/food_crud_view_model.dart';
import '../../view models/controllers/food_view_model.dart';
import '../../view models/controllers/uploader_view_model.dart';
import '../../view models/controllers/vendor_restaurant_view_model.dart';
import 'widgets/all_categories.dart';
import 'widgets/image_upload.dart';

class AddFoodsScreen extends StatefulWidget {
  const AddFoodsScreen({super.key});

  @override
  State<AddFoodsScreen> createState() => _AddFoodsScreenState();
}

class _AddFoodsScreenState extends State<AddFoodsScreen> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController prepration = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController additivesTitles = TextEditingController();
  final TextEditingController additivesPrice = TextEditingController();
  final PageController _pageController = PageController();
  @override
  void dispose() {
    title.dispose();
    price.dispose();
    type.dispose();
    prepration.dispose();
    description.dispose();
    additivesTitles.dispose();
    additivesPrice.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitFood(
    FoodController foodCtrl,
    FoodCrudController crudCtrl,
    UploaderController uploader,
    VendorRestaurantController vendorCtrl,
  ) async {
    // Validate required fields
    if (title.text.trim().isEmpty ||
        description.text.trim().isEmpty ||
        prepration.text.trim().isEmpty ||
        price.text.trim().isEmpty) {
      Utils.showWarning('Missing info', 'Please fill all fields in the form.');
      return;
    }
    if (foodCtrl.category.isEmpty) {
      Utils.showWarning('No category', 'Please pick a category.');
      return;
    }
    if (foodCtrl.type.isEmpty) {
      Utils.showWarning('No food type', 'Add at least one food type.');
      return;
    }
    if (uploader.image.isEmpty) {
      Utils.showWarning('No image', 'Please upload at least one image.');
      return;
    }

    final restaurantId = vendorCtrl.activeId;
    if (restaurantId == null || restaurantId.isEmpty) {
      Utils.showError('No restaurant',
          'Create or select a restaurant before adding foods.');
      return;
    }

    final parsedPrice = double.tryParse(price.text.trim()) ?? 0.0;

    final body = {
      'title': title.text.trim(),
      'description': description.text.trim(),
      'time': prepration.text.trim(),
      'price': parsedPrice,
      'category': foodCtrl.category,
      'foodTags': <String>[foodCtrl.category],
      'foodType': foodCtrl.type.toList(),
      'code': '123456',
      'restaurant': restaurantId,
      'imageUrl': uploader.image,
      'additives': foodCtrl.addivitesList
          .map((a) => {
                'id': a.id,
                'title': a.title,
                'price': a.price,
              })
          .toList(),
    };

    final ok = await crudCtrl.createFood(body);
    if (ok) {
      // Reset form + state
      title.clear();
      description.clear();
      prepration.clear();
      price.clear();
      type.clear();
      additivesTitles.clear();
      additivesPrice.clear();
      foodCtrl.setCategory = '';
      foodCtrl.clearAddittives();
      foodCtrl.type.clear();
      uploader.image.clear();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodController());
    final crud = Get.put(FoodCrudController());
    final uploader = Get.put(UploaderController());
    final vendor = Get.put(VendorRestaurantController());

    // Hard guard: vendor must have a Verified restaurant. Anything else
    // (no restaurant, Pending, Rejected) cannot add foods.
    final noRestaurant = vendor.activeId == null || vendor.activeId!.isEmpty;
    if (noRestaurant || !vendor.isVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (noRestaurant) {
          Utils.showWarning(
              'No restaurant', 'Submit your restaurant application first.');
        } else {
          Utils.showWarning(
            'Not verified',
            vendor.verificationStatus == 'Rejected'
                ? 'Your application was rejected.'
                : 'Your restaurant is still under admin review.',
          );
        }
        Get.offAllNamed(RouteName.restaurantScreen);
      });
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: kPrimary)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: kSecondary,
        leading: const AppBackButton(),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReuseableText(
              text: 'Welcome to Restaurant Panel',
              fontSize: 14.spMin,
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
            ReuseableText(
              text: 'Fill all the required info to add food item',
              fontSize: 10.spMin,
              fontWeight: FontWeight.normal,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: kWhite,
        child: ListView(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                pageSnapping: false,
                children: [
                  ChooseCategory(
                    next: () {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                  ),
                  ImageUpload(
                    back: () {
                      // Reset the category
                      controller.setCategory = '';

                      // Navigate back to the category selection page
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    next: () {
                      // Proceed to the next page
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),

                  // ImageUpload(
                  //   back: () {
                  //     controller.setCategory = '';
                  //     print(controller.category);
                  //     // _pageController.previousPage(
                  //     //     duration: const Duration(milliseconds: 500),
                  //     //     curve: Curves.easeIn);
                  //     // Get.back();
                  //     Get.offAllNamed(RouteName.AddFoodsScreen);
                  //   },
                  //   next: () {
                  //     _pageController.nextPage(
                  //         duration: const Duration(milliseconds: 500),
                  //         curve: Curves.easeIn);
                  //   },
                  // ),
                  // ChooseCategory(
                  //   next: () {
                  //     _pageController.nextPage(
                  //         duration: const Duration(milliseconds: 500),
                  //         curve: Curves.easeIn);
                  //   },
                  // ),
                  FoodInfo(
                    back: () {
                      controller.setType = '';
                      // Navigate back to the category selection page
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    next: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    title: title,
                    description: description,
                    prepration: prepration,
                    price: price,
                    type: type,
                  ),
                  Obx(() => AdditivesInfo(
                        additivesTitles: additivesTitles,
                        additivesPrice: additivesPrice,
                        isSubmitting: crud.isSubmitting,
                        onSubmit: () => _submitFood(
                            controller, crud, uploader, vendor),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
