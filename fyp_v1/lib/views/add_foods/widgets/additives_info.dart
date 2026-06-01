import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/coustom_button.dart';
import '../../../common/res/components/coustom_textformfield.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../models/additives_models.dart';
import '../../../view models/controllers/food_view_model.dart';

class AdditivesInfo extends StatelessWidget {
  const AdditivesInfo({
    super.key,
    required this.additivesTitles,
    required this.additivesPrice,
    this.onSubmit,
    this.isSubmitting = false,
  });

  final TextEditingController additivesTitles;
  final TextEditingController additivesPrice;
  final Future<void> Function()? onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodController());
    return SizedBox(
      height: height, // Adjust the height as needed
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: 'Add Additives Info',
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.w600,
                ),
                ReuseableText(
                  text:
                      'You are required to add additives info for your if it has any.',
                  fontSize: 11.spMin,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h),
          SizedBox(
            height: height * 0.8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    hintText: "Additives Title",
                    prefixIcon: const Icon(Icons.keyboard_capslock),
                    controller: additivesTitles,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextFormField(
                    hintText: "Additives Price",
                    prefixIcon: const Icon(Icons.keyboard_capslock),
                    controller: additivesPrice,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Obx(
                    () => controller.addivitesList.isNotEmpty
                        ? Column(
                            children: List.generate(
                              controller.addivitesList.length,
                              (i) {
                                final additives = controller.addivitesList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 18.h),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    decoration: BoxDecoration(
                                      color: kGray,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ReuseableText(
                                              text: additives.title,
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              textColor: kWhite,
                                            ),
                                            ReuseableText(
                                              text:
                                                  "\$ ${additives.price.toString()}",
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              textColor: kWhite,
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomButton(
                    btnHeight: 30.h,
                    btnWidth: MediaQuery.of(context).size.width,
                    radius: 9.r,
                    onTap: () {
                      if (additivesPrice.text.isNotEmpty &&
                          additivesTitles.text.isNotEmpty) {
                        Additives additives = Additives(
                            id: controller.genrateId(),
                            title: additivesTitles.text,
                            price: additivesPrice.text);

                        controller.addAddivites = additives;
                        additivesPrice.text = '';
                        additivesTitles.text = '';
                      } else {
                        Get.snackbar(
                            colorText: kLightWhite,
                            backgroundColor: kPrimary,
                            'You need to add addtives!',
                            'Please fill all fields');
                      }
                    },
                    text: 'ADD ADDITIVES',
                  ),
                  SizedBox(height: 20.h),
                  if (onSubmit != null)
                    CustomButton(
                      btnHeight: 44.h,
                      btnWidth: MediaQuery.of(context).size.width,
                      radius: 9.r,
                      btnColor: isSubmitting ? kSecondary : kPrimary,
                      onTap: isSubmitting ? null : () => onSubmit!(),
                      text: isSubmitting ? 'Saving…' : 'SAVE FOOD',
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
