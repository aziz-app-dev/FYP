import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/components/reuseable_text.dart';

class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget(
      {super.key, required this.title, required this.icon, this.onTap});
  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: Icon(
          icon,
          size: 20.spMin,
        ),
        title: ReuseableText(
          text: title,
          fontSize: 11,
          textColor: kGray,
          fontWeight: FontWeight.normal,
        ),
        trailing: title != "Settings"
            ? Icon(
                AntDesign.right,
                size: 16.spMin,
              )
            : Image.asset(
                'assets/flag.png',
                height: 20,
              )
        // CachedNetworkImage(
        //     imageUrl:
        //         'https://lh3.googleusercontent.com/proxy/wdHDFvqfsC7LQkD79lPpONBeAIV5JElwwwQnX8XkRdDzeakz1qYngvm4Av3-7tqiWLVPeD-Ys94NiD35I-os2ezrmZYQZVSdSQlaSuIiHQyjLkDnPyjEM42rsZ80AnW8pQ',
        //     height: 20.h,
        //     width: 15.w,
        //   ),
        );
  }
}
