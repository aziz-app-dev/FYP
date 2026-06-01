import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../res/colors/app_color.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void _toast(String message, Color bg) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: bg,
      textColor: kLightWhite,
      fontSize: 14,
    );
  }

  /// Basic snackbar
  static void snackBar(String title, String message) {
    _toast('$title: $message', kPrimary);
  }

  /// Success toast (green)
  static void showSuccess(String title, String message, {Widget? icon}) {
    _toast('$title\n$message', kPrimary);
  }

  /// Error toast (red)
  static void showError(String title, String message, {Widget? icon}) {
    _toast('$title\n$message', kRed);
  }

  /// Warning toast (orange/secondary)
  static void showWarning(String title, String message, {Widget? icon}) {
    _toast('$title\n$message', kSecondary);
  }

  /// Info toast (gray)
  static void showInfo(String title, String message, {Widget? icon}) {
    _toast('$title\n$message', kGray);
  }

  /// Custom toast
  static void showCustomSnackbar({
    required String title,
    required String message,
    Color? colorText,
    Color? backgroundColor,
    Widget? icon,
    dynamic snackPosition,
  }) {
    _toast('$title\n$message', backgroundColor ?? kPrimary);
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
  "Pending",
  "Preparing",
  "Delivering",
  "Delivered",
  "Cancelled",
];

// Vendor order statuses (more granular)
List<String> vendorOrderList = [
  "New Orders",
  "Preparing",
  "Ready",
  "Picked Up",
  "Self-Deliveries",
  "Delivered",
  "Cancelled",
];
