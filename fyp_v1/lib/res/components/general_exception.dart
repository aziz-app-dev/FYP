import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';

class GeneralExceptionWidget extends StatefulWidget {
  const GeneralExceptionWidget({
    super.key,
  });

  @override
  State<GeneralExceptionWidget> createState() => _GeneralExceptionWidgetState();
}

class _GeneralExceptionWidgetState extends State<GeneralExceptionWidget> {
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
                SizedBox(
                  height: 50.h,
                ),
                //  AssetImage('assets/1.jpg'),

                CircleAvatar(
                  backgroundColor: kPrimary.withOpacity(.5),
                  radius: 150.spMin,
                  child: Image.asset(
                    'assets/server.png',
                    // scale: 4.spMin,
                    fit: BoxFit.contain,
                    height: 150.spMin,
                    width: 150.spMin,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                const ReuseableText(
                  text: '500',
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  textColor: kGray,
                ),
                SizedBox(
                  height: 10.h,
                ),
                const ReuseableText(
                  text: 'We have an internal server error.',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.h,
                ),
                const ReuseableText(
                  text: 'Please try again later!',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  textColor: kGray,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.h,
                ),
                // CustomButton(
                //   onTap: () {},
                //   btnHeight: 40.h,
                //   btnWidth: width,
                //   child: const Center(
                //     child: ReuseableText(
                //       text: 'R E T R Y',
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //       textColor: Colors.white,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
