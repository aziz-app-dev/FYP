import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/config/theme/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget appLoader({Color color = AppColors.primary, double size = 40}) {
  return Center(
    child: LoadingAnimationWidget.fourRotatingDots(
      size: size.spMin,
      color: color,
    ),
  );
}
