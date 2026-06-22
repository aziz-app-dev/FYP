import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen utility helpers for responsive design
/// Uses flutter_screenutil for adaptive sizing across different screen sizes
///
/// For responsive sizing, use the built-in extensions from flutter_screenutil:
/// - .w for responsive width
/// - .h for responsive height
/// - .sp for responsive font size
/// - .r for responsive radius
///
/// Example:
/// ```dart
/// Container(
///   width: 100.w,
///   height: 50.h,
///   child: Text('Hello', style: TextStyle(fontSize: 18.sp)),
/// )
/// ```

/// Screen utility class for common responsive operations
class ScreenUtils {
  ScreenUtils._();
  static bool isWatch(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 300;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  // Check if device is tablet
  static bool isSmallMob(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return width >= 300 && width <= 600;
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width <= 1024;
  }

  // Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 1024;
  }

  /// Design size constants (iPhone 13/14 Pro)
  static const double designWidth = 375;
  static const double designHeight = 812;

  /// Get screen width
  static double get screenWidth => ScreenUtil().screenWidth;

  /// Get screen height
  static double get screenHeight => ScreenUtil().screenHeight;

  /// Get status bar height
  static double get statusBarHeight => ScreenUtil().statusBarHeight;

  /// Get bottom bar height (for devices with home indicator)
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;

  /// Check if device is tablet
  static bool get isTab => ScreenUtil().screenWidth >= 600;

  /// Check if device is in landscape mode
  static bool get isLandscape =>
      ScreenUtil().screenWidth > ScreenUtil().screenHeight;

  /// Get adaptive value based on device type
  static T adaptive<T>({required T mobile, required T tablet}) {
    return isTab ? tablet : mobile;
  }

  /// Get responsive padding
  static EdgeInsets paddingAll(double value) => EdgeInsets.all(value.w);

  static EdgeInsets paddingHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value.w);

  static EdgeInsets paddingVertical(double value) =>
      EdgeInsets.symmetric(vertical: value.h);

  static EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: left.w,
    top: top.h,
    right: right.w,
    bottom: bottom.h,
  );

  /// Get responsive border radius
  static BorderRadius borderRadius(double radius) =>
      BorderRadius.circular(radius.r);

  static BorderRadius borderRadiusOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft.r),
    topRight: Radius.circular(topRight.r),
    bottomLeft: Radius.circular(bottomLeft.r),
    bottomRight: Radius.circular(bottomRight.r),
  );

  /// Get responsive SizedBox
  static SizedBox verticalSpace(double height) => SizedBox(height: height.h);
  static SizedBox horizontalSpace(double width) => SizedBox(width: width.w);

  /// Common spacing helpers
  static SizedBox get verticalSpaceXs => SizedBox(height: 4.h);
  static SizedBox get verticalSpaceSm => SizedBox(height: 8.h);
  static SizedBox get verticalSpaceMd => SizedBox(height: 16.h);
  static SizedBox get verticalSpaceLg => SizedBox(height: 24.h);
  static SizedBox get verticalSpaceXl => SizedBox(height: 32.h);
  static SizedBox get verticalSpaceXxl => SizedBox(height: 48.h);

  static SizedBox get horizontalSpaceXs => SizedBox(width: 4.w);
  static SizedBox get horizontalSpaceSm => SizedBox(width: 8.w);
  static SizedBox get horizontalSpaceMd => SizedBox(width: 16.w);
  static SizedBox get horizontalSpaceLg => SizedBox(width: 24.w);
  static SizedBox get horizontalSpaceXl => SizedBox(width: 32.w);
}

/// Widget extension for responsive sizing
extension ResponsiveWidget on Widget {
  /// Add responsive padding
  Widget withPadding(EdgeInsets padding) =>
      Padding(padding: padding, child: this);

  /// Add responsive margin using Container
  Widget withMargin(EdgeInsets margin) =>
      Container(margin: margin, child: this);
}
