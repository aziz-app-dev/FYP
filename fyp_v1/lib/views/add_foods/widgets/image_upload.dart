import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/app_network_image.dart';
import '../../../common/res/components/coustom_button.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../view models/controllers/uploader_view_model.dart';

// class ImageUpload extends StatelessWidget {
//   const ImageUpload({super.key, required this.back, required this.next});

//   final Function() back;
//   final Function() next;

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(UploaderController());
//     return SizedBox(
//         height: height,
//         child: ListView(children: [
//           Padding(
//               padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ReuseableText(
//                       text: 'Upload Images',
//                       fontSize: 16.spMin,
//                       fontWeight: FontWeight.w600),
//                   ReuseableText(
//                       text: 'You are required to upload images to proceed',
//                       fontSize: 11.spMin,
//                       fontWeight: FontWeight.normal),
//                 ],
//               )),
//           SizedBox(
//             height: height,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       //!  image 1
//                       GestureDetector(
//                         onTap: () {
//                           controller.pickImage('one');
//                         },
//                         child: Container(
//                           height: 120.h,
//                           width: width / 2.3,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             border: Border.all(color: kGray),
//                           ),
//                           child: const Center(
//                             child: ReuseableText(
//                                 text: 'Upload Image',
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ),
//                       //!  image 2
//                       GestureDetector(
//                         onTap: () {
//                           controller.pickImage('two');
//                         },
//                         child: Container(
//                           height: 120.h,
//                           width: width / 2.3,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             border: Border.all(color: kGray),
//                           ),
//                           child: const Center(
//                             child: ReuseableText(
//                                 text: 'Upload Image',
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       //!  image 3
//                       GestureDetector(
//                         onTap: () {
//                           controller.pickImage('three');
//                         },
//                         child: Container(
//                           height: 120.h,
//                           width: width / 2.3,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             border: Border.all(color: kGray),
//                           ),
//                           child: const Center(
//                             child: ReuseableText(
//                                 text: 'Upload Image',
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ),
//                       //!  image 4
//                       GestureDetector(
//                         onTap: () {
//                           controller.pickImage('four');
//                         },
//                         child: Container(
//                           height: 120.h,
//                           width: width / 2.3,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             border: Border.all(color: kGray),
//                           ),
//                           child: const Center(
//                             child: ReuseableText(
//                                 text: 'Upload Image',
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                    SizedBox(height: 25.h),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     CustomButton(
//       btnHeight: 30.h,
//       btnWidth: width / 2.3,
//       radius: 9.r,
//       onTap: () {
//         // Use the page controller to navigate back instead of Get.offAllNamed
//         back();
//       },
//       text: 'Back',
//     ),
//     CustomButton(
//       btnHeight: 30.h,
//       btnWidth: width / 2.3,
//       radius: 9.r,
//       onTap: () {
//         next();
//       },
//       text: 'Next',
//     ),
//   ],
// ),
//                 ],
//               ),
//             ),
//           )
//         ]));
//   }
// }

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
                              : AppNetworkImage(
                                  imageUrl: controller.imageOneUrl,
                                  borderRadius: BorderRadius.circular(10.r),
                                  fit: BoxFit.cover,
                                  fallbackIcon: Icons.image_outlined,
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
                              : AppNetworkImage(
                                  imageUrl: controller.imageTwoUrl,
                                  borderRadius: BorderRadius.circular(10.r),
                                  fit: BoxFit.contain,
                                  fallbackIcon: Icons.image_outlined,
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
                              : AppNetworkImage(
                                  imageUrl: controller.imageThreeUrl,
                                  borderRadius: BorderRadius.circular(10.r),
                                  fit: BoxFit.contain,
                                  fallbackIcon: Icons.image_outlined,
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
                              : AppNetworkImage(
                                  imageUrl: controller.imageFourUrl,
                                  borderRadius: BorderRadius.circular(10.r),
                                  fit: BoxFit.contain,
                                  fallbackIcon: Icons.image_outlined,
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
