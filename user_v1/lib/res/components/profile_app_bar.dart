import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';

class ProfileAAppBar extends StatelessWidget {
  const ProfileAAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kOffWhite,
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Row(
              children: [
                Image.asset(
                  'assets/flag.png',
                  height: 15,
                ),

                // CachedNetworkImage(
                //   imageUrl:
                //       'https://lh3.googleusercontent.com/proxy/wdHDFvqfsC7LQkD79lPpONBeAIV5JElwwwQnX8XkRdDzeakz1qYngvm4Av3-7tqiWLVPeD-Ys94NiD35I-os2ezrmZYQZVSdSQlaSuIiHQyjLkDnPyjEM42rsZ80AnW8pQ',
                //   height: 25.h,
                //   width: 15.w,
                // ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                  height: 15.h,
                  width: 1.w,
                  color: kGrayLight,
                ),
                SizedBox(
                  width: 5.w,
                ),
                const ReuseableText(
                  text: 'Pakistan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Icon(
                      // Icons.settings
                      SimpleLineIcons.settings,
                      size: 20.spMin,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
