import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config.dart';
import 'app_btn.dart';

/// A reusable result/confirmation dialog with:
///   - Top icon or custom widget
///   - Title
///   - Description message
///   - Primary button (filled)
///   - Optional secondary button (outlined)
///
/// Usage:
/// ```dart
/// AppResultDialog.show(
///   context,
///   icon: Icon(Icons.check_circle, size: 48, color: colors.success),
///   title: 'Congratulations!',
///   message: 'You successfully made a payment.\nEnjoy your service',
///   primaryLabel: 'Track Order',
///   onPrimary: () => Navigator.pushNamed(context, RouteName.tracking),
///   secondaryLabel: 'Go to Home',
///   onSecondary: () => Navigator.pop(context),
/// );
/// ```
class AppResultDialog extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool barrierDismissible;

  const AppResultDialog({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.barrierDismissible = false,
  });

  /// Show as a centered dialog
  static Future<T?> show<T>(
    BuildContext context, {
    Widget? icon,
    required String title,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimary,
    String? secondaryLabel,
    VoidCallback? onSecondary,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppResultDialog(
        icon: icon,
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 32.spMin),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.spMin,
          vertical: 28.spMin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Icon ────────────────────────────────────
            if (icon != null) ...[
              icon!,
              SizedBox(height: 20.spMin),
            ],

            // ─── Title ───────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.spMin),

            // ─── Message ─────────────────────────────────
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.spMin),

            // ─── Primary Button ──────────────────────────
            AppButton(
              text: primaryLabel,
              onPressed: onPrimary,
            ),

            // ─── Secondary Button ────────────────────────
            if (secondaryLabel != null && onSecondary != null) ...[
              SizedBox(height: 10.spMin),
              AppButton(
                text: secondaryLabel!,
                onPressed: onSecondary!,
                backgroundColor: Colors.transparent,
                textColor: colors.textPrimary,
                borderColor: colors.textPrimary,
                borderWidth: 1.5,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
