// ! BottomSheet
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/utils.dart';
import '../../view/user/address/shipping_address_view.dart';
import '../../view/user/auth/login/login_redirect.dart';
import '../colors/app_color.dart';
import 'reuseable_text.dart';
import 'round_button.dart';

Future<dynamic> showAddressSheet(BuildContext context) {
  final box = GetStorage();
  String? token = box.read("token");
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Container(
          height: 800.h,
          width: width,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.fill,
            ), // DecorationImage
            color: kLightWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ), // BorderRadius.only
          ), // BoxDecoration
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                const ReuseableText(
                  text: 'Add Address',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  textColor: kPrimary,
                ),
                SizedBox(
                  height: 250.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        reasonsToAddAddress.length,
                        (index) {
                          return ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              color: kPrimary,
                            ),
                            title: ReuseableText(
                              text: reasonsToAddAddress[index],
                              fontSize: 10,
                              textAlign: TextAlign.justify,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                RoundButton(
                  title: 'Go to add address',
                  height: 35.h,
                  width: width,
                  buttonColor: kPrimary,
                  textColor: kLightWhite,
                  onPress: () {
                    if (token == null) {
                      Get.to(() => const LoginRedirect());
                    } else {
                      Get.to(() => const ShippingAddressScreen());
                    }
                  },
                )
              ],
            ),
          ),
        ); // Container
      });
}
