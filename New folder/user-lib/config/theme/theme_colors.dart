import 'package:flutter/material.dart';

/// Theme-aware color system for the Food Delivery App
/// Usage: context.colors.bottomNav or ThemeColors.of(context).bottomNav
class ThemeColors {
  final Brightness brightness;

  const ThemeColors._({required this.brightness});

  /// Light theme colors
  static const ThemeColors light = ThemeColors._(brightness: Brightness.light);

  /// Dark theme colors
  static const ThemeColors dark = ThemeColors._(brightness: Brightness.dark);

  /// Get ThemeColors based on current theme
  static ThemeColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;

  // ============== Primary Colors ==============
  Color get primary => const Color(0xFFFF6B35);
  Color get primaryLight => const Color(0xFFFF8E53);
  Color get primaryDark => const Color(0xFFE55A2B);
  Color get primaryAccent => const Color(0xFFFFA726);

  // ============== Secondary Colors ==============
  Color get secondary => const Color(0xFFFF7043);
  Color get secondaryLight => const Color(0xFFFF8A65);
  Color get secondaryDark => const Color(0xFFE64A19);
  Color get secondaryAccent => const Color(0xFFFF9E80);

  // ============== Tertiary Colors ==============
  Color get tertiary => const Color(0xFF4A148C);
  Color get tertiaryLight => const Color(0xFF7B1FA2);
  Color get tertiaryDark => const Color(0xFF311B92);

  // ============== Background Colors ==============
  Color get background =>
      isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);

  Color get background2 =>
      isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8FAFC);

  Color get scaffoldBackground =>
      isDark ? const Color.fromARGB(255, 37, 36, 36) : const Color(0xFFf8f9fa);

  Color get surface =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);

  Color get surfaceVariant =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5);

  Color get card => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);

  // ============== Navigation Colors ==============
  Color get bottomNav =>
      //  isDark ? const Color(0xFFF8F8F8) :
      primary;
  // isDark ? const Color(0xFFF8F8F8) : const Color(0xFF1A1A1A);

  Color get bottomNavIcon =>
      // isDark ? const Color(0xFF0A0A0A) :
      const Color(0xFFFFFFFF);
  Color get bottomNavIconBg =>
      // isDark ? const Color(0xFF0A0A0A) :
      const Color.fromARGB(251, 12, 12, 12);

  Color get bottomNavIconActive =>
      isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFFFFFF);

  Color get sideNav =>
      isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);

  // ============== Text Colors ==============
  Color get textPrimary =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);

  Color get textSecondary =>
      isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);

  Color get textTertiary =>
      isDark ? const Color(0xFF909090) : const Color(0xFF9E9E9E);

  Color get textHint =>
      isDark ? const Color(0xFF808080) : const Color(0xFF9E9E9E);

  Color get textDisabled =>
      isDark ? const Color(0xFF606060) : const Color(0xFFBDBDBD);

  Color get textOnPrimary => const Color(0xFFFFFFFF);
  Color get textOnSecondary => const Color(0xFFFFFFFF);

  // ============== Input/Form Colors ==============
  Color get fillColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8);

  Color get inputBackground =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5);

  Color get inputBorder =>
      isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0);

  Color get inputBorderFocused => primary;

  // ============== Status Colors ==============
  Color get success => const Color(0xFF4CAF50);
  Color get successLight =>
      isDark ? const Color(0xFF1B3D1E) : const Color(0xFFE8F5E9);

  Color get error => const Color(0xFFE53935);
  Color get errorLight =>
      isDark ? const Color(0xFF3D1B1B) : const Color(0xFFFFEBEE);

  Color get warning => const Color(0xFFFFC107);
  Color get warningLight =>
      isDark ? const Color(0xFF3D3514) : const Color(0xFFFFF8E1);

  Color get info => const Color(0xFF2196F3);
  Color get infoLight =>
      isDark ? const Color(0xFF14293D) : const Color(0xFFE3F2FD);

  // ============== UI Element Colors ==============
  Color get divider =>
      isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0);

  Color get border =>
      isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0);

  Color get shadow =>
      isDark ? const Color(0x40000000) : const Color(0x1A000000);

  Color get overlay => const Color(0x80000000);

  // ============== Rating & Favorite Colors ==============
  Color get star => const Color(0xFFFFC107);
  Color get heart => const Color(0xFFE53935);
  Color get heartLight =>
      isDark ? const Color(0xFF3D1B1B) : const Color(0xFFFFCDD2);

  // ============== Card Colors ==============
  Color get cardBackground =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);

  Color get cardShadow =>
      isDark ? const Color(0x00000000) : const Color(0x1A000000);

  // ============== Button Colors ==============
  Color get buttonPrimary => primary;
  Color get buttonPrimaryText => const Color(0xFFFFFFFF);
  Color get buttonSecondary =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5);
  Color get buttonSecondaryText =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);
  Color get buttonDisabled =>
      isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0);
  Color get buttonDisabledText =>
      isDark ? const Color(0xFF808080) : const Color(0xFF9E9E9E);

  // ============== Chip/Tag Colors ==============
  Color get chipBackground =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);

  Color get chipText =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF424242);

  Color get chipSelectedBackground => primary;
  Color get chipSelectedText => const Color(0xFFFFFFFF);

  // ============== Modal/Dialog Colors ==============
  Color get modalBackground =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);

  Color get modalBarrier => const Color(0x80000000);

  // ============== Header Colors ==============
  Color get headerBackground =>
      isDark ? const Color(0x1A000000) : const Color(0xFFFFFFFF);

  Color get headerText =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);

  // ============== App Bar Colors ==============
  Color get appBarBackground =>
      isDark ? const Color(0x1A000000) : const Color(0xFFFFFFFF);

  Color get appBarText =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);

  Color get appBarIcon =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);

  // ============== Tab Bar Colors ==============
  Color get tabBarBackground =>
      isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);

  Color get tabBarIndicator => primary;
  Color get tabBarSelected => primary;
  Color get tabBarUnselected =>
      isDark ? const Color(0xFF808080) : const Color(0xFF9E9E9E);

  // ============== Shimmer Colors ==============
  Color get shimmerBase =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);

  Color get shimmerHighlight =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

  // ============== Icon Colors ==============
  Color get iconPrimary =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);

  Color get iconSecondary =>
      isDark ? const Color(0xFF808080) : const Color(0xFF757575);

  Color get iconDisabled =>
      isDark ? const Color(0xFF505050) : const Color(0xFFBDBDBD);

  Color get onboradverColor =>
      isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  // ============== Gradients ==============
  LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53), Color(0xFFFFA726)],
  );

  LinearGradient get secondaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7043), Color(0xFFE64A19)],
  );

  LinearGradient get cardGradient => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
        );

  LinearGradient get gradient1 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE55A2B), Color(0xFFFF6B35)],
  );
  LinearGradient get gradient2 => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF8E53), Color(0xFFFF6B35)],
  );
  LinearGradient get gradient3 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFFF8E53),
      Color.fromARGB(255, 235, 150, 24),
    ],
  );
  LinearGradient get gradient4 => const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFFF6B35), Color(0xFFE64A19)],
  );
  LinearGradient get gradient5 => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
  );
  LinearGradient get gradient6 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFF7043)],
  );
  LinearGradient get gradient7 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFFE55A2B), Color(0xFFFF6B35), Color(0xFFFFA726)],
  );
  LinearGradient get gradient8 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFF8A65)],
  );
  LinearGradient get gradient9 => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE64A19), Color(0xFFFF6B35)],
  );
  LinearGradient get gradient10 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFBF360C)],
  );
}

/// Extension on BuildContext for easy access to theme colors
extension ThemeColorsExtension on BuildContext {
  /// Access theme-aware colors: context.colors.primary
  ThemeColors get colors => ThemeColors.of(this);

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}
