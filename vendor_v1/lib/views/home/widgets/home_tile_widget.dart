import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';

class HomeTileWidget extends StatelessWidget {
  const HomeTileWidget(
      {super.key, required this.iconPath, this.onTap, required this.text});

  final String iconPath;
  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 35.w,
            height: 35.h,
          ),
          ReuseableText(
            text: text,
            fontSize: 10.spMin,
            fontWeight: FontWeight.w500,
            textColor: kGray,
          )
        ],
      ),
    );
  }
}
