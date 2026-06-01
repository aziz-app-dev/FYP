import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../common/res/components/coustom_button.dart';
import '../../../common/res/components/coustom_textformfield.dart';
import '../../../view models/controllers/food_view_model.dart';

class FoodInfo extends StatelessWidget {
  const FoodInfo(
      {super.key,
      required this.back,
      required this.next,
      required this.title,
      required this.description,
      required this.prepration,
      required this.price,
      required this.type});
  final Function back;
  final Function next;

  final TextEditingController title;
  final TextEditingController description;
  final TextEditingController prepration;
  final TextEditingController price;
  final TextEditingController type;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodController());
    return SizedBox(
      height: height,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h),
            // padding: EdgeInsets.only(left: 12.w, bottom: 12.h, top: 12.h),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: 'Add Details',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: kGray,
                ),
                ReuseableText(
                  text: 'You are required to information corectly',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  textColor: kGray,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ! tile
                CustomTextFormField(
                  hintText: "Tile",
                  prefixIcon: const Icon(Icons.keyboard_capslock),
                  controller: title,
                ),
                SizedBox(
                  height: 15.h,
                ),
                // !Add food descriptions
                CustomTextFormField(
                  hintText: "Add food descriptions",
                  prefixIcon: const Icon(Icons.keyboard_capslock),
                  maxLine: 5,
                  controller: description,
                ),
                SizedBox(
                  height: 15.h,
                ),
                // ! Food preparation time e.g 10 min
                CustomTextFormField(
                  hintText: "Food preparation time e.g 10 min",
                  prefixIcon: const Icon(Icons.keyboard_capslock),
                  controller: prepration,
                ),
                SizedBox(
                  height: 15.h,
                ),
                // ! Price
                CustomTextFormField(
                  hintText: "Price with no currency e.g 100",
                  prefixIcon: const Icon(Icons.price_change_rounded),
                  controller: price,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 5.h,
                ),
                // !  add food type
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.h),
            // padding: EdgeInsets.only(left: 12.w, bottom: 12.h, top: 12.h),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: 'Add Food Type',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: kGray,
                ),
                ReuseableText(
                  text:
                      'You are required to type and type helps with food search',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  textColor: kGray,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Obx(
              () {
                return Column(
                  children: [
                    CustomTextFormField(
                      hintText: "Breakfast / Lunch / Dinner / Snacks / Drinks",
                      prefixIcon: const Icon(Icons.keyboard_capslock),
                      controller: type,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    controller.type.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            child: Row(
                              children: List.generate(
                                controller.type.length,
                                (i) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                      color: kPrimary,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: ReuseableText(
                                          text: controller.type[i],
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal,
                                          textColor: kWhite,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomButton(
                      onTap: () {
                        controller.setType = type.text;
                        type.text = '';
                      },
                      btnHeight: 30,
                      text: 'Add Food Type',
                      btnColor: kSecondary,
                      radius: 6,
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  btnHeight: 30.h,
                  btnWidth: MediaQuery.of(context).size.width / 2.3,
                  radius: 9.r,
                  onTap: () {
                    // Use the page controller to navigate back instead of Get.offAllNamed
                    back();
                  },
                  text: 'Back',
                ),
                CustomButton(
                  btnHeight: 30.h,
                  btnWidth: MediaQuery.of(context).size.width / 2.3,
                  radius: 9.r,
                  onTap: () {
                    next();
                  },
                  text: 'Next',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
