import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../../res/res_imports.dart';

/// Confirmation dialog shown after a successful order placement.
/// Displays the order summary + "Track Order" and "Continue" actions.
Future<void> showOrderSuccessDialog({
  required String orderId,
  required int itemCount,
  required double grandTotal,
}) {
  return Get.dialog<void>(
    Dialog(
      backgroundColor: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36.r,
              backgroundColor: kPrimary.withOpacity(0.12),
              child: Icon(
                Ionicons.checkmark_circle,
                color: kPrimary,
                size: 52.spMin,
              ),
            ),
            SizedBox(height: 16.h),
            const ReuseableText(
              text: 'Order Placed!',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: kDark,
            ),
            SizedBox(height: 4.h),
            const ReuseableText(
              text: 'Congratulations, your order is being prepared.',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textColor: kGray,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  _row('Order ID',
                      '#${orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId}'),
                  SizedBox(height: 6.h),
                  _row('Items', '$itemCount'),
                  SizedBox(height: 6.h),
                  _row('Total', '\$ ${grandTotal.toStringAsFixed(2)}'),
                  SizedBox(height: 6.h),
                  _row('Payment', 'Cash on delivery'),
                  SizedBox(height: 6.h),
                  _row('Status', 'Pending'),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      side: const BorderSide(color: kPrimary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                    ),
                    onPressed: () {
                      Get.back(); // close dialog
                      Get.offAllNamed(RouteName.mainScreen);
                    },
                    child: const ReuseableText(
                      text: 'Continue',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: kPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.toNamed(RouteName.UserOrderScreen);
                    },
                    child: const ReuseableText(
                      text: 'Track Order',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: kLightWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

Widget _row(String a, String b) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ReuseableText(
        text: a,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        textColor: kGray,
      ),
      ReuseableText(
        text: b,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        textColor: kDark,
      ),
    ],
  );
}
