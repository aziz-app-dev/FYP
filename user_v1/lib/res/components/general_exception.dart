import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';
import 'coustom_button.dart';
import 'reuseable_text.dart';

class GeneralExceptionWidget extends StatelessWidget {
  /// Optional retry callback. When provided, a Retry button is rendered
  /// at the bottom of the screen.
  final VoidCallback? onRetry;

  /// Optional custom subtitle (e.g., the actual error message).
  final String? subtitle;

  const GeneralExceptionWidget({
    super.key,
    this.onRetry,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                CircleAvatar(
                  backgroundColor: kPrimary.withOpacity(.5),
                  radius: 150.spMin,
                  child: Image.asset(
                    'assets/server.png',
                    fit: BoxFit.contain,
                    height: 150.spMin,
                    width: 150.spMin,
                  ),
                ),
                SizedBox(height: 30.h),
                const ReuseableText(
                  text: '500',
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  textColor: kGray,
                ),
                SizedBox(height: 10.h),
                const ReuseableText(
                  text: 'We have an internal server error.',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.h),
                ReuseableText(
                  text: subtitle ?? 'Please try again later!',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                if (onRetry != null)
                  CustomButton(
                    onTap: onRetry,
                    btnHeight: 44.h,
                    btnWidth: 180.w,
                    btnColor: kPrimary,
                    radius: 10.r,
                    child: const Center(
                      child: ReuseableText(
                        text: 'R E T R Y',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
