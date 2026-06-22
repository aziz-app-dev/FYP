import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/widgets/app_btn.dart';
import 'package:lottie/lottie.dart';
import '../config.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final bool isNoInternet;
  final bool fullScreen;

  const AppErrorWidget({
    super.key,
    this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.isNoInternet = false,
    this.fullScreen = false,
  });

  // Factory for no internet error
  factory AppErrorWidget.noInternet({
    VoidCallback? onRetry,
    bool fullScreen = false,
  }) {
    return AppErrorWidget(
      isNoInternet: true,
      title: "No Internet Connection",
      message: "Please check your network settings and try again",
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      fullScreen: fullScreen,
    );
  }

  // Factory for server error
  factory AppErrorWidget.serverError({
    String? message,
    VoidCallback? onRetry,
    bool fullScreen = false,
  }) {
    return AppErrorWidget(
      title: "Server Error",
      message: message ?? "Something went wrong. Please try again later",
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
      fullScreen: fullScreen,
    );
  }

  // Factory for general error
  factory AppErrorWidget.general({
    String? title,
    String? message,
    VoidCallback? onRetry,
    bool fullScreen = false,
  }) {
    return AppErrorWidget(
      title: title ?? "Oops!",
      message: message ?? "Something went wrong",
      icon: Icons.error_outline_rounded,
      onRetry: onRetry,
      fullScreen: fullScreen,
    );
  }

  Widget _buildIconFallback(ThemeColors colors, IconData iconData) {
    return Container(
      width: 150.spMin,
      height: 150.spMin,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 70.spMin, color: colors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if we have bounded height (can use Expanded)
        final hasBoundedHeight = constraints.maxHeight != double.infinity;

        final content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            isNoInternet
                ? Lottie.asset(
                    'assets/lottie/No Internet Connection.json',
                    width: 180.spMin,
                    height: 180.spMin,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildIconFallback(colors, Icons.wifi_off_rounded),
                  )
                : _buildIconFallback(
                    colors,
                    icon ?? Icons.error_outline_rounded,
                  ),
            SizedBox(height: 32.spMin),

            // Title
            Text(
              title ?? "Error",
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.spMin),

            // Message
            Text(
              message ?? "An error occurred",
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

        final button = onRetry != null
            ? Padding(
                padding: EdgeInsets.only(bottom: 32.spMin),
                child: AppButton(text: "Try Again", onPressed: onRetry!),
              )
            : null;

        // If bounded height, use Expanded layout with button at bottom
        if (hasBoundedHeight) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.spMin),
            child: Column(
              children: [
                Expanded(child: Center(child: content)),
                if (button != null) button,
              ],
            ),
          );
        }

        // If fullScreen and unbounded, use SizedBox with screen height
        if (fullScreen) {
          final screenHeight = MediaQuery.sizeOf(context).height;
          final topPadding = MediaQuery.of(context).padding.top;
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          // Account for app bar and bottom nav (~200)
          final availableHeight = screenHeight - topPadding - bottomPadding - 200.spMin;

          return SizedBox(
            height: availableHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.spMin),
              child: Column(
                children: [
                  Expanded(child: Center(child: content)),
                  if (button != null) button,
                ],
              ),
            ),
          );
        }

        // If unbounded height (inside ListView), calculate viewport height for centering
        final screenHeight = MediaQuery.sizeOf(context).height;
        final topPadding = MediaQuery.of(context).padding.top;
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        // Use 60% of available screen height for proper centering in ListView
        final viewportHeight = (screenHeight - topPadding - bottomPadding) * 0.7;

        return SizedBox(
          height: viewportHeight,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.spMin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  content,
                  if (button != null) SizedBox(height: 40.spMin),
                  if (button != null) button,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper function to check if error is network related
bool isNetworkError(String? errorMessage) {
  if (errorMessage == null) return false;
  final lowerMessage = errorMessage.toLowerCase();
  return lowerMessage.contains('socket') ||
      lowerMessage.contains('network') ||
      lowerMessage.contains('connection') ||
      lowerMessage.contains('timeout') ||
      lowerMessage.contains('failed host lookup') ||
      lowerMessage.contains('no internet') ||
      lowerMessage.contains('unreachable');
}
