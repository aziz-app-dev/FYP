import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lottie/lottie.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/components/coustom_button.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../view_models/varification/varification_view_model.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VarificationController());
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text('Please varify your Account'),
        centerTitle: true,
        backgroundColor: kWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.h),
          child: Container(
            height: height,
            width: width,
            color: kWhite,
            child: Column(
              children: [
                SizedBox(
                  height: height,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                          height: 220.h,
                          width: width,
                          child: Lottie.asset('assets/ani2.json')),
                      SizedBox(height: 30.h),
                      const ReuseableText(
                        text: 'Verify Your Account',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        textColor: kPrimary,
                      ),
                      SizedBox(height: 10.h),
                      const ReuseableText(
                        text:
                            'Enter the 6- digit code sent to your email, if  you can not see the code, Please check your spam folder',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        textColor: kGray,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 25.h),
                      // ! OtpTextField
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: kPrimary,
                        showFieldAsBox: false,
                        borderWidth: 2.0,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textStyle: const TextStyle(
                            fontSize: 17,
                            color: kPrimary,
                            fontWeight: FontWeight.w600),
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          // print(verificationCode);
                          controller.setCode = verificationCode;
                        }, // end onSubmit
                      ),
                      SizedBox(height: 25.h),
                      // ! button
                      CustomButton(
                        onTap: () {
                          controller.varificationFunction();
                        },
                        btnColor: kPrimary,
                        btnHeight: 40.h,
                        btnWidth: width,
                        child: const Center(
                          child: ReuseableText(
                            text: 'V E R F Y  A C C O U N T',
                            textColor: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
