import 'package:flutter/material.dart';
import 'app_sizes.dart';

/// App text styles for the Food Delivery App
/// Base styles without colors - use with context.textStyles for theme-aware colors
class AppTextStyles {
  AppTextStyles._();

  // ============== Font Family ==============
  static const String fontFamily = 'Roboto';

  // ============== Display Styles ==============
  static TextStyle displayLarge = TextStyle(
    fontSize: AppSizes.font6Xl,
    fontWeight: FontWeight.bold,
    height: AppSizes.lineHeightTight,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: AppSizes.font5Xl,
    fontWeight: FontWeight.bold,
    height: AppSizes.lineHeightTight,
  );

  static TextStyle displaySmall = TextStyle(
    fontSize: AppSizes.font4Xl,
    fontWeight: FontWeight.bold,
    height: AppSizes.lineHeightTight,
  );

  // ============== Headline Styles ==============
  static TextStyle headlineLarge = TextStyle(
    fontSize: AppSizes.font3Xl,
    fontWeight: FontWeight.bold,
    height: AppSizes.lineHeightTight,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: AppSizes.fontXxl,
    fontWeight: FontWeight.bold,
    height: AppSizes.lineHeightTight,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: AppSizes.fontXl,
    fontWeight: FontWeight.w600,
    height: AppSizes.lineHeightNormal,
  );

  // ============== Title Styles ==============
  static TextStyle titleLarge = TextStyle(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w600,
    height: AppSizes.lineHeightNormal,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    height: AppSizes.lineHeightNormal,
  );

  static TextStyle titleSmall = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w600,
    height: AppSizes.lineHeightNormal,
  );

  // ============== Body Styles ==============
  static TextStyle bodyLarge = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.normal,
    height: AppSizes.lineHeightNormal,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.normal,
    height: AppSizes.lineHeightNormal,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.normal,
    height: AppSizes.lineHeightNormal,
  );

  // ============== Label Styles ==============
  static TextStyle labelLarge = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
  );

  static TextStyle labelSmall = TextStyle(
    fontSize: AppSizes.fontXxs,
    fontWeight: FontWeight.w500,
    letterSpacing: AppSizes.letterSpacingWide,
  );

  // ============== Button Styles ==============
  static TextStyle buttonLarge = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
  );

  static TextStyle buttonMedium = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w600,
  );

  static TextStyle buttonSmall = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w600,
  );

  // ============== Splash Screen Styles ==============
  static TextStyle splashTitle = TextStyle(
    fontSize: AppSizes.font6Xl,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: AppSizes.letterSpacingWider,
    shadows: [
      Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
    ],
  );

  static TextStyle splashSubtitle = TextStyle(
    fontSize: AppSizes.fontMd,
    color: Colors.white.withValues(alpha: 0.9),
    letterSpacing: AppSizes.letterSpacingWide,
  );

  static TextStyle splashLoading = TextStyle(
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: AppSizes.fontSm,
  );

  // ============== Onboarding Styles ==============
  static TextStyle onboardingLabel = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWidest,
  );

  static TextStyle onboardingTitle = TextStyle(
    fontSize: AppSizes.font5Xl,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: AppSizes.lineHeightTight,
  );

  static TextStyle onboardingDescription(Color color) => TextStyle(
    fontSize: AppSizes.fontMd,
    color: color,
    height: AppSizes.lineHeightNormal,
  );

  // ============== Price Styles ==============
  static TextStyle priceLarge = TextStyle(
    fontSize: AppSizes.fontXl,
    fontWeight: FontWeight.bold,
  );

  static TextStyle priceMedium = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.bold,
  );

  // ============== Rating Styles ==============
  static TextStyle ratingText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: AppSizes.fontSm,
  );

  static TextStyle ratingCount = TextStyle(fontSize: AppSizes.fontXs);

  // ============== Badge Styles ==============
  static TextStyle badgeText = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w600,
  );

  static TextStyle chipText = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w600,
  );

  // ============== Helper Methods ==============
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}

/// Theme-aware text styles
/// Usage: context.textStyles.displayLarge or ThemedTextStyles.of(context).displayLarge
class ThemedTextStyles {
  final Brightness brightness;

  const ThemedTextStyles._({required this.brightness});

  /// Light theme text styles
  static const ThemedTextStyles light = ThemedTextStyles._(
    brightness: Brightness.light,
  );

  /// Dark theme text styles
  static const ThemedTextStyles dark = ThemedTextStyles._(
    brightness: Brightness.dark,
  );

  /// Get ThemedTextStyles based on current theme
  static ThemedTextStyles of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;

  // ============== Theme-aware Text Colors ==============
  Color get textPrimary =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);

  Color get textSecondary =>
      isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);

  Color get textHint =>
      isDark ? const Color(0xFF808080) : const Color(0xFF9E9E9E);

  Color get textDisabled =>
      isDark ? const Color(0xFF606060) : const Color(0xFFBDBDBD);

  Color get textOnPrimary => const Color(0xFFFFFFFF);

  Color get primary => const Color(0xFFFF6B35);

  // ============== Display Styles ==============
  TextStyle get displayLarge =>
      AppTextStyles.displayLarge.copyWith(color: textPrimary);
  TextStyle get displayMedium =>
      AppTextStyles.displayMedium.copyWith(color: textPrimary);
  TextStyle get displaySmall =>
      AppTextStyles.displaySmall.copyWith(color: textPrimary);

  // ============== Headline Styles ==============
  TextStyle get headlineLarge =>
      AppTextStyles.headlineLarge.copyWith(color: textPrimary);
  TextStyle get headlineMedium =>
      AppTextStyles.headlineMedium.copyWith(color: textPrimary);
  TextStyle get headlineSmall =>
      AppTextStyles.headlineSmall.copyWith(color: textPrimary);

  // ============== Title Styles ==============
  TextStyle get titleLarge =>
      AppTextStyles.titleLarge.copyWith(color: textPrimary);
  TextStyle get titleMedium =>
      AppTextStyles.titleMedium.copyWith(color: textPrimary);
  TextStyle get titleSmall =>
      AppTextStyles.titleSmall.copyWith(color: textPrimary);

  // ============== Body Styles ==============
  TextStyle get bodyLarge =>
      AppTextStyles.bodyLarge.copyWith(color: textPrimary);
  TextStyle get bodyMedium =>
      AppTextStyles.bodyMedium.copyWith(color: textPrimary);
  TextStyle get bodySmall =>
      AppTextStyles.bodySmall.copyWith(color: textSecondary);

  // ============== Label Styles ==============
  TextStyle get labelLarge =>
      AppTextStyles.labelLarge.copyWith(color: textPrimary);
  TextStyle get labelMedium =>
      AppTextStyles.labelMedium.copyWith(color: textPrimary);
  TextStyle get labelSmall =>
      AppTextStyles.labelSmall.copyWith(color: textSecondary);

  // ============== Button Styles ==============
  TextStyle get buttonLarge =>
      AppTextStyles.buttonLarge.copyWith(color: textOnPrimary);
  TextStyle get buttonMedium =>
      AppTextStyles.buttonMedium.copyWith(color: textOnPrimary);
  TextStyle get buttonSmall =>
      AppTextStyles.buttonSmall.copyWith(color: textOnPrimary);

  // ============== Price Styles ==============
  TextStyle get priceLarge => AppTextStyles.priceLarge.copyWith(color: primary);
  TextStyle get priceMedium =>
      AppTextStyles.priceMedium.copyWith(color: textOnPrimary);

  // ============== Rating Styles ==============
  TextStyle get ratingText =>
      AppTextStyles.ratingText.copyWith(color: textPrimary);
  TextStyle get ratingCount =>
      AppTextStyles.ratingCount.copyWith(color: textSecondary);

  // ============== Badge Styles ==============
  TextStyle get badgeText =>
      AppTextStyles.badgeText.copyWith(color: textPrimary);
  TextStyle get chipText => AppTextStyles.chipText.copyWith(color: textPrimary);

  // ============== Onboarding Styles ==============
  TextStyle get onboardingLabel =>
      AppTextStyles.onboardingLabel.copyWith(color: primary);
}

/// Extension for easy access to themed text styles
extension ThemedTextStylesExtension on BuildContext {
  /// Access theme-aware text styles: context.textStyles.displayLarge
  ThemedTextStyles get textStyles => ThemedTextStyles.of(this);
}
