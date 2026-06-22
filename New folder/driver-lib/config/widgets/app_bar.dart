import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../theme/app_text_styles.dart';

enum HeaderVerticalPadding { none, top, bottom, both }

class CustomHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final bool? showBackButton;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final HeaderVerticalPadding verticalPadding;

  const CustomHeader({
    super.key,
    this.title,
    this.onBack,
    this.action,
    this.showBackButton,
    this.padding,
    this.verticalPadding = HeaderVerticalPadding.both,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? _buildPadding();

    return Padding(
      padding: effectivePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBackButton ?? true)
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: Icon(TablerIcons.chevron_left, size: 24.spMin),
            ),
          if (showBackButton ?? true) SizedBox(width: 16.spMin),
          Expanded(
            child: Text(
              title ?? "",
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }

  EdgeInsets _buildPadding() {
    final h = 16.spMin;
    final v = 12.spMin;

    return switch (verticalPadding) {
      HeaderVerticalPadding.none => EdgeInsets.symmetric(horizontal: h),
      _ => EdgeInsets.symmetric(horizontal: h, vertical: v),
    };
  }
}
