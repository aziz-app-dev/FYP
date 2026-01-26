export 'app_sizes.dart';
export 'app_urls.dart';
export 'storage_keys.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'BLoC Template';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);

  // API Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Input Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
}
