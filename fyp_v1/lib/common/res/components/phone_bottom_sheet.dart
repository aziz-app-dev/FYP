// ! BottomSheet
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';
import 'round_button.dart';
import '../../utils/utils.dart';

Future<dynamic> showVerificationSheet(BuildContext context) {
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
                  text: 'Verify Your Phone Number',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  textColor: kPrimary,
                ),
                SizedBox(
                  height: 250.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        verificationReasons.length,
                        (index) {
                          return ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              color: kPrimary,
                            ),
                            title: ReuseableText(
                              text: verificationReasons[index],
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
                  title: 'Verify Phone Number',
                  height: 35.h,
                  width: width,
                  buttonColor: kPrimary,
                  textColor: kLightWhite,
                  onPress: () {},
                )
              ],
            ),
          ),
        ); // Container
      });
}
