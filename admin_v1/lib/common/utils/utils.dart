import 'package:flutter/material.dart';

import '../res/colors/app_color.dart';

class Utils {
  /// Global ScaffoldMessenger key plugged into `GetMaterialApp` so we
  /// can show styled 2-line snackbars from any controller without
  /// worrying about Overlay/context availability.
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void _show(
    String title,
    String message,
    Color bg, {
    IconData icon = Icons.info_outline,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint('[Utils] Toast dropped: $title — $message');
      return;
    }
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: bg.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: kLightWhite, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: kLightWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        color: kLightWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void snackBar(String title, String message) {
    _show(title, message, kPrimary);
  }

  static void showSuccess(String title, String message) {
    _show(title, message, kPrimary, icon: Icons.check_circle_outline);
  }

  static void showError(String title, String message) {
    _show(title, message, kRed, icon: Icons.error_outline);
  }

  static void showWarning(String title, String message) {
    _show(title, message, kSecondary, icon: Icons.warning_amber_rounded);
  }

  static void showInfo(String title, String message) {
    _show(title, message, kGray, icon: Icons.info_outline);
  }
}
