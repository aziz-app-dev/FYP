import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/components/coustom_button.dart';
import '../../../../res/components/reuseable_text.dart';
import '../../../../view_models/controller/vendor/uploader_controller.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({super.key, required this.back, required this.next});

  final Function() back;
  final Function() next;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploaderController());
    return SizedBox(
      height: 400.h, // Adjust the height as needed
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReuseableText(
                  text: 'Upload Images',
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.w600,
                ),
                ReuseableText(
                  text:
                      'You are required to upload at last two images to proceed',
                  fontSize: 11.spMin,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //!  Image 1
                    GestureDetector(
                      onTap: () => controller.pickImage('one'),
                      child: Obx(
                        () => Container(
                          height: 120.h,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(color: kGray, width: 3),
                          ),
                          child: controller.imageOneUrl.isEmpty
                              ? const Center(
                                  child: ReuseableText(
                                      text: 'Upload Image',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    controller.imageOneUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    //!  Image 2
                    GestureDetector(
                      onTap: () => controller.pickImage('two'),
                      child: Obx(
                        () => Container(
                          height: 120.h,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(10.r),
                            // border: Border.all(color: kGray),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(color: kGray, width: 3),
                          ),
                          child: controller.imageTwoUrl.isEmpty
                              ? const Center(
                                  child: ReuseableText(
                                      text: 'Upload Image',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    controller.imageTwoUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //!  Image 3
                    GestureDetector(
                      onTap: () => controller.pickImage('three'),
                      child: Obx(
                        () => Container(
                          height: 120.h,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(10.r),
                            // border: Border.all(color: kGray),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(color: kGray, width: 3),
                          ),
                          child: controller.imageThreeUrl.isEmpty
                              ? const Center(
                                  child: ReuseableText(
                                      text: 'Upload Image',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    controller.imageThreeUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    //!  Image 4
                    GestureDetector(
                      onTap: () => controller.pickImage('four'),
                      child: Obx(
                        () => Container(
                          height: 120.h,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(10.r),
                            // border: Border.all(color: kGray),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(color: kGray, width: 3),
                          ),
                          child: controller.imageFourUrl.isEmpty
                              ? const Center(
                                  child: ReuseableText(
                                      text: 'Upload Image',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    controller.imageFourUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35.h),
                Row(
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

                        // if (controller.image.length > 1) {
                        //   next();
                        // } else {
                        //   Get.snackbar(
                        //       colorText: kLightWhite,
                        //       backgroundColor: kPrimary,
                        //       'Error',
                        //       'Please upload at least two image');
                        // }
                      },
                      text: 'Next',
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
