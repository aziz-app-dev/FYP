import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/utils/screen_utils.dart';

import '../../utils/loaders_utils.dart';
import '../config.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  final double borderWidth;
  final double? borderRadius;
  final double height;

  final IconData? icon;
  final double iconSize;
  final double iconSpacing;
  final double? width;
  final double? fontSize;

  final bool isLoading;
  final FocusNode? node;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderRadius,
    this.height = 45,
    this.icon,
    this.iconSize = 18,
    this.iconSpacing = 8,
    this.isLoading = false,
    this.node,
    this.width,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTransparent = backgroundColor == Colors.transparent;

    // Responsive width: full width on mobile, constrained on tablet/desktop
    final double buttonWidth = ScreenUtils.isDesktop(context)
        ? 320.spMin
        : double.infinity;

    return SizedBox(
      height: height.spMin,
      width: width ?? buttonWidth,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(
            isLoading ? Colors.transparent : backgroundColor,
          ),
          overlayColor: WidgetStateProperty.all(
            isTransparent
                ? Colors.transparent
                : backgroundColor.withValues(alpha: 0.1),
          ),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 16.spMin, vertical: 0),
          ),
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppSizes.radiusMd,
              ),
              side: BorderSide(color: borderColor, width: borderWidth),
            ),
          ),
        ),
        focusNode: node,
        child: isLoading
            ? appLoader()
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize, color: textColor),
                    SizedBox(width: iconSpacing),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize ?? 14.spMin,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
