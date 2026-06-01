import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/reuseable_text.dart';

/// One quick-action tile on the vendor home screen.
///
/// Uses a Material icon so we don't have to ship extra PNG assets.
class HomeTileWidget extends StatelessWidget {
  const HomeTileWidget({
    super.key,
    required this.icon,
    this.onTap,
    required this.text,
  });

  final IconData icon;
  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28.spMin, color: kPrimary),
            SizedBox(height: 2.h),
            ReuseableText(
              text: text,
              fontSize: 10.spMin,
              fontWeight: FontWeight.w500,
              textColor: kGray,
            ),
          ],
        ),
      ),
    );
  }
}
