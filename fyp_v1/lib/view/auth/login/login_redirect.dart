import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/components/coustom_button.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../res/routes/routes_name.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const ReuseableText(
          text: 'Please login to access this page',
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90.h),
              SizedBox(
                  height: 250.h,
                  width: width,
                  child: Lottie.asset('assets/ani2.json')),
              SizedBox(height: 50.h),
              CustomButton(
                radius: 9.r,
                btnColor: kPrimary,
                btnHeight: 40.h,
                btnWidth: width,
                child: const Center(
                  child: ReuseableText(
                    text: 'L O G I N',
                    textColor: Colors.white,
                  ),
                ),
                onTap: () {
                  Get.toNamed(RouteName.LoginScreen);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
