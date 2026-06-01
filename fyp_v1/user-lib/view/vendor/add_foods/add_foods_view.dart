import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../view_models/controller/vendor/vendor_food_controller.dart';
import 'widgets/additives_info.dart';
import 'widgets/all_categories.dart';
import 'widgets/food_info.dart';
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorFoodController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: kSecondary,
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
                  AdditivesInfo(
                      additivesTitles: additivesTitles,
                      additivesPrice: additivesPrice)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
