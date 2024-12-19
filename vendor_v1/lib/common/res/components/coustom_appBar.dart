// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 100.h,
      padding: EdgeInsets.fromLTRB(12.w, 1.h, 12.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.spMin,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/1.jpg'),
              ),
              Padding(
                padding: EdgeInsets.all(8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReuseableText(
                      text: 'Kings Foods',
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w700,
                      textColor: Colors.white,
                    ),
                    ReuseableText(
                      text: '187 LaFoods Street Union City, NJ 07087',
                      fontSize: 10.spMin,
                      fontWeight: FontWeight.normal,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/open.png',
            height: 30.spMin,
          )
        ],
      ),
    );
  }
}
