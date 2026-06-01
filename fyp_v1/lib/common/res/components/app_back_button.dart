import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// iOS-style back button used as the leading widget in every AppBar.
/// Uses `CupertinoIcons.back` so the arrow looks the same on Android
/// and iOS. Pops with GetX so it's also safe in routes pushed via
/// `Get.to(...)`.
class AppBackButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.color = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.back,
        color: color,
        size: 22.spMin,
      ),
      splashRadius: 22,
      onPressed: onPressed ?? () => Get.back(),
    );
  }
}
