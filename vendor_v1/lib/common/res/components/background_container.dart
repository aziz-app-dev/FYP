import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../assets/image_assets.dart';
import '../colors/app_color.dart';

class BackGroundContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const BackGroundContainer(
      {super.key, required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          image: const DecorationImage(
              image: AssetImage(ImageAssets.bgImage),
              fit: BoxFit.cover,
              opacity: 0.7)),
      child: child,
    );
  }
}
