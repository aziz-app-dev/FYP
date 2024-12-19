import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // static toastMessage(String message){
  //   Fluttertoast.showToast(
  //       msg: message ,
  //     backgroundColor: AppColor.blackColor ,
  //     textColor: AppColor.whiteColor,
  //     gravity: ToastGravity.BOTTOM,
  //     toastLength: Toast.LENGTH_LONG,

  //   );
  // }

  // static toastMessageCenter(String message){
  //   Fluttertoast.showToast(
  //     msg: message ,
  //     backgroundColor: AppColor.blackColor ,
  //     gravity: ToastGravity.CENTER,
  //     toastLength: Toast.LENGTH_LONG,
  //     textColor: AppColor.whiteColor,
  //   );
  // }

  static snackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
    );
  }
}

final List<String> verificationReasons = [
  'Real-time Updates: Get instant notifications about your order status.',
  'Direct Communication: A verified number ensures seamless communication.',
  'Enhanced Security: Protect your account and confirm orders securely.',
  'Effortless Rescheduling: Easily address issues with a quick call.',
  'Exclusive Offers: Stay in the loop for special deals and promotions.'
];

List<String> reasonsToAddAddress = [
  "Ensures that food orders are delivered accurately to the customer's location.",
  "Allows users to check if the delivery service is available in their area.",
  "Provides a personalized experience by showing nearby restaurants, estimated delivery times, and special offers.",
  "Streamlines the checkout process by saving addresses for quicker order placement.",
  "Enables management of multiple addresses (e.g., home, work) for easy switching.",
];

List<String> orderList = [
  "New Orders",
  "Preparing",
  "Ready",
  "Picked Up",
  "Self-Deliveries",
  "Delivered",
  "Cancelled",
];
