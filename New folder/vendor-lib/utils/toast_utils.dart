import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/config.dart';

/// Toast/Flushbar utility class for showing notifications
/// Uses theme-aware colors for dark/light mode support
class ToastUtils {
  ToastUtils._();

  // Track currently showing Flushbar to dismiss before showing new one
  static Flushbar? _currentFlushbar;
  static bool _isShowingFlushbar = false;

  static String _compactMessage(String message, {int maxChars = 220}) {
    final compact = message.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (compact.length <= maxChars) return compact;
    return '${compact.substring(0, maxChars)}...';
  }

  /// Show success toast
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: message,
      title: title ?? 'Success',
      icon: Icons.check_circle_outline,
      backgroundColor: colors.success,
      textColor: colors.textOnPrimary,
      duration: duration,
    );
  }

  /// Show error toast
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: message,
      title: title ?? 'Error',
      icon: Icons.error_outline,
      backgroundColor: colors.error,
      textColor: colors.textOnPrimary,
      duration: duration,
    );
  }

  /// Show warning toast
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: message,
      title: title ?? 'Warning',
      icon: Icons.warning_amber_outlined,
      backgroundColor: colors.warning,
      textColor: colors.textPrimary,
      duration: duration,
    );
  }

  /// Show info toast
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: message,
      title: title ?? 'Info',
      icon: Icons.info_outline,
      backgroundColor: colors.info,
      textColor: colors.textOnPrimary,
      duration: duration,
    );
  }

  /// Show custom toast
  static void showCustom(
    BuildContext context, {
    required String message,
    String? title,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: message,
      title: title,
      icon: icon ?? Icons.notifications_outlined,
      backgroundColor: backgroundColor ?? colors.primary,
      textColor: textColor ?? colors.textOnPrimary,
      duration: duration,
      position: position,
    );
  }

  /// Show loading toast (stays until dismissed)
  static Flushbar? showLoading(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    if (!context.mounted) return null;

    // Dismiss any existing flushbar first
    _dismissCurrentFlushbar();

    final colors = context.colors;
    final flushbar = Flushbar(
      title: title ?? 'Loading',
      message: message,
      icon: SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors.textOnPrimary),
        ),
      ),
      backgroundColor: colors.tertiary,
      titleColor: colors.textOnPrimary,
      messageColor: colors.textOnPrimary.withValues(alpha: 0.8),
      duration: const Duration(days: 1),
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      borderRadius: BorderRadius.circular(12.r),
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible: false,
      blockBackgroundInteraction: false,
    );

    // Use post-frame callback to avoid route lifecycle conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      try {
        flushbar.show(context);
      } catch (e) {
        // Ignore show errors
      }
    });

    return flushbar;
  }

  /// Show OTP sent toast
  static void showOtpSent(BuildContext context, {String? phoneOrEmail}) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: phoneOrEmail != null
          ? 'OTP sent to $phoneOrEmail'
          : 'OTP has been sent successfully',
      title: 'OTP Sent',
      icon: Icons.sms_outlined,
      backgroundColor: colors.secondary,
      textColor: colors.textOnPrimary,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show OTP verified toast
  static void showOtpVerified(BuildContext context) {
    final colors = context.colors;
    _showFlushbar(
      context,
      message: 'Your phone number has been verified',
      title: 'Verified',
      icon: Icons.verified_outlined,
      backgroundColor: colors.success,
      textColor: colors.textOnPrimary,
      duration: const Duration(seconds: 3),
    );
  }

  /// Internal method to show flushbar
  static void _showFlushbar(
    BuildContext context, {
    required String message,
    String? title,
    required IconData icon,
    required Color backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    // Check if context is still valid
    if (!context.mounted) return;

    // Prevent showing if already showing (debounce rapid calls)
    if (_isShowingFlushbar) return;
    _isShowingFlushbar = true;

    // Dismiss any existing flushbar safely
    _dismissCurrentFlushbar();

    // Use post-frame callback to avoid route lifecycle conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        _isShowingFlushbar = false;
        return;
      }

      try {
        final colors = context.colors;
        final effectiveTextColor = textColor ?? colors.textOnPrimary;
        final safeTitle =
            title == null ? null : _compactMessage(title, maxChars: 80);
        final safeMessage = _compactMessage(message);

        final flushbar = Flushbar(
          titleText: safeTitle == null
              ? null
              : Text(
                  safeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: effectiveTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          messageText: Text(
            safeMessage,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelMedium.copyWith(
              color: effectiveTextColor.withValues(alpha: 0.9),
            ),
          ),
          icon: Icon(
            icon,
            color: effectiveTextColor,
            size: 24.spMin,
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          margin: EdgeInsets.all(6.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          borderRadius: BorderRadius.circular(12.r),
          flushbarPosition: position,
          animationDuration: const Duration(milliseconds: 400),
          forwardAnimationCurve: Curves.easeOut,
          reverseAnimationCurve: Curves.easeIn,
          blockBackgroundInteraction: false,
          boxShadows: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          onStatusChanged: (status) {
            if (status == FlushbarStatus.DISMISSED ||
                status == FlushbarStatus.IS_HIDING) {
              _isShowingFlushbar = false;
              _currentFlushbar = null;
            }
          },
        );

        _currentFlushbar = flushbar;
        flushbar.show(context);
      } catch (e) {
        _isShowingFlushbar = false;
        _currentFlushbar = null;
        // Fallback to SnackBar if Flushbar fails
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: backgroundColor,
              behavior: SnackBarBehavior.floating,
              duration: duration,
            ),
          );
        }
      }
    });
  }

  /// Safely dismiss current flushbar
  static void _dismissCurrentFlushbar() {
    try {
      if (_currentFlushbar != null) {
        _currentFlushbar?.dismiss();
        _currentFlushbar = null;
      }
    } catch (e) {
      // Ignore dismiss errors
      _currentFlushbar = null;
    }
  }

  /// Dismiss any visible flushbar
  static void dismiss(Flushbar? flushbar) {
    try {
      flushbar?.dismiss();
    } catch (e) {
      // Ignore dismiss errors during navigation
    }
    // Also dismiss current tracked flushbar
    _dismissCurrentFlushbar();
    _isShowingFlushbar = false;
  }

  /// Dismiss all flushbars and reset state
  static void dismissAll() {
    _dismissCurrentFlushbar();
    _isShowingFlushbar = false;
  }
}
