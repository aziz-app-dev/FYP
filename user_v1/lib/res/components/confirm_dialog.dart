import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';

/// App-level confirmation popup.
///
/// Returns `true` if confirmed, `false`/`null` if dismissed.
///
/// ```dart
/// final confirmed = await showConfirmDialog(
///   icon: Icons.delete_outline_rounded,
///   title: 'Delete this Blog ?',
///   subtitle: 'You will not be able to recover it once deleted.',
/// );
/// ```
Future<bool?> showConfirmDialog({
  required IconData icon,
  required String title,
  String? subtitle,
  String confirmText = 'Yes',
  String cancelText = 'Cancel',
  Color iconColor = kRed,
  Color confirmColor = kRed,
}) {
  return Get.dialog<bool>(
    Dialog(
      backgroundColor: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(
                  iconColor.red.toInt(),
                  iconColor.green.toInt(),
                  iconColor.blue.toInt(),
                  0.1,
                ),
              ),
              child: Icon(icon, color: iconColor, size: 28.spMin),
            ),
            SizedBox(height: 16.h),

            // Title
            ReuseableText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: kDark,
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              ReuseableText(
                text: subtitle,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: kGray,
                textAlign: TextAlign.center,
              ),
            ],

            SizedBox(height: 20.h),

            // Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(158, 158, 158, 0.4),
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: ReuseableText(
                        text: cancelText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textColor: kDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Confirm
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: true),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: confirmColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: ReuseableText(
                        text: confirmText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textColor: kLightWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
