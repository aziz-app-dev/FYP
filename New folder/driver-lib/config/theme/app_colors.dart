import 'package:flutter/material.dart';

/// App color palette for the Food Delivery App
class AppColors {
  AppColors._();

  // ============== Primary Colors ==============
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8E53);
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryAccent = Color(0xFFFFA726);

  // ============== Secondary Colors (Coral Pink) ==============
  static const Color secondary = Color(0xFFFF7043);
  static const Color secondaryLight = Color(0xFFFF8A65);
  static const Color secondaryDark = Color(0xFFE64A19);
  static const Color secondaryAccent = Color(0xFFFF9E80);

  // ============== Tertiary Colors (Deep Plum) ==============
  static const Color tertiary = Color(0xFF4A148C);
  static const Color tertiaryLight = Color(0xFF7B1FA2);
  static const Color tertiaryDark = Color(0xFF311B92);

  // ============== Background Colors ==============
  static const Color black = Color(0xFF0A0A0A);
  static const Color bootomNav = Color(0xFF0A0A0A);
  static const Color sideNav = Color(0xFF0A0A0A);
  static const Color bootomNavLight = Color(0xFFF8F8F8); // for bottom
  static const Color sideNavLight = Color(0xFFF8F8F8); // for side nav

  static const Color bootomNavbg = Color(0xFF424242);
  static const Color bootomNavIcon = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);
  static const Color background2 = Color(0xffF8FAFC);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color scaffoldBackgroundDark = Color(0xFF0A0A0A);

  // ============== Text Colors ==============
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color fillColor = Color(0xFFE8E8E8);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // ============== Status Colors ==============
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ============== UI Element Colors ==============
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
  static const Color overlay = Color(0x80000000);

  // ============== Rating & Favorite Colors ==============
  static const Color star = Color(0xFFFFC107);
  static const Color heart = Color(0xFFE53935);
  static const Color heartLight = Color(0xFFFFCDD2);

  // ============== Onboarding Specific Colors ==============
  static const Color onboardingBg1 = Color(0xFFFFF8E1);
  static const Color onboardingBg1End = Color(0xFFFFECB3);
  static const Color onboardingBg2 = Color(0xFF4A148C); // Deep Plum
  static const Color onboardingBg3Start = Color(0xFFFBE9E7); // Coral tint
  static const Color onboardingBg3Mid = Color(0xFFFFCCBC); // Coral light
  static const Color onboardingBg3End = Color(0xFFFFAB91); // Coral medium

  // ============== Splash Screen Colors ==============
  static const Color splashGradientStart = Color(0xFFFF6B35);
  static const Color splashGradientMid = Color(0xFFFF8E53);
  static const Color splashGradientEnd = Color(0xFFFFA726);

  // ============== Gradients ==============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight, primaryAccent],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [splashGradientStart, splashGradientMid, splashGradientEnd],
  );

  static const LinearGradient onboarding1Gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [onboardingBg1, onboardingBg1End],
  );

  static RadialGradient onboarding3Gradient = const RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [onboardingBg3Start, onboardingBg3Mid, onboardingBg3End],
  );

  // ============== Helper Methods ==============
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
