import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../res/colors/app_color.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// Shows a snackbar safely, ensuring the overlay is available
  static void _safeSnackbar({
    required String title,
    required String message,
    Color? colorText,
    Color? backgroundColor,
    Widget? icon,
    SnackPosition snackPosition = SnackPosition.TOP,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar(
          title,
          message,
          colorText: colorText,
          backgroundColor: backgroundColor,
          icon: icon,
          snackPosition: snackPosition,
        );
      }
    });
  }

  /// Basic snackbar
  static void snackBar(String title, String message) {
    _safeSnackbar(
      title: title,
      message: message,
      colorText: kLightWhite,
      backgroundColor: kPrimary,
    );
  }

  /// Success snackbar (green)
  static void showSuccess(String title, String message, {Widget? icon}) {
    _safeSnackbar(
      title: title,
      message: message,
      colorText: kLightWhite,
      backgroundColor: kPrimary,
      icon: icon ?? const Icon(Icons.check_circle_outline, color: kLightWhite),
    );
  }

  /// Error snackbar (red)
  static void showError(String title, String message, {Widget? icon}) {
    _safeSnackbar(
      title: title,
      message: message,
      colorText: kLightWhite,
      backgroundColor: kRed,
      icon: icon ?? const Icon(Icons.error_outline, color: kLightWhite),
    );
  }

  /// Warning snackbar (orange/secondary)
  static void showWarning(String title, String message, {Widget? icon}) {
    _safeSnackbar(
      title: title,
      message: message,
      colorText: kLightWhite,
      backgroundColor: kSecondary,
      icon:
          icon ?? const Icon(Icons.warning_amber_outlined, color: kLightWhite),
    );
  }

  /// Info snackbar (gray)
  static void showInfo(String title, String message, {Widget? icon}) {
    _safeSnackbar(
      title: title,
      message: message,
      colorText: kLightWhite,
      backgroundColor: kGray,
      icon: icon ?? const Icon(Icons.info_outline, color: kLightWhite),
    );
  }

  /// Custom snackbar with full control
  static void showCustomSnackbar({
    required String title,
    required String message,
    Color? colorText,
    Color? backgroundColor,
    Widget? icon,
    SnackPosition snackPosition = SnackPosition.TOP,
  }) {
    _safeSnackbar(
      title: title,
      message: message,
      colorText: colorText ?? kLightWhite,
      backgroundColor: backgroundColor ?? kPrimary,
      icon: icon,
      snackPosition: snackPosition,
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
  "Pending",
  // "Placed",
  "Preparing",
  // "Out For Delivery",
  // "Manual",
  "Delivering",
  "Delivered",
  "Cancelled",
  // "Ready",
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
