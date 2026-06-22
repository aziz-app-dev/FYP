import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

Widget sectionTitle(
  String title, {
  void Function()? onTap,
  required BuildContext context,
}) {
  final colors = context.colors;

  return Row(
    spacing: 10.spMin,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(color: colors.textPrimary),
        ),
      ),
      InkWell(
        onTap: onTap,
        child: Text(
          'See all',
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}
