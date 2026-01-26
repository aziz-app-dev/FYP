import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/color.dart';
import '../constants/app_sizes.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  // App Bar Theme
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: AppSizes.fontTitle,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Color Scheme
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.secondaryDark,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.border,
  ),

  // Scaffold
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,

  // Text Selection
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: AppColors.primaryLight,
    selectionHandleColor: AppColors.primary,
  ),

  // Progress Indicator
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: AppColors.grey200,
    color: AppColors.primary,
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.grey100,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSizes.paddingM,
      vertical: AppSizes.paddingM,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    labelStyle: GoogleFonts.roboto(
      color: AppColors.textSecondary,
      fontSize: AppSizes.fontM,
    ),
    hintStyle: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontSize: AppSizes.fontM,
    ),
    errorStyle: GoogleFonts.roboto(
      color: AppColors.error,
      fontSize: AppSizes.fontS,
    ),
    helperStyle: GoogleFonts.roboto(
      color: AppColors.textSecondary,
      fontSize: AppSizes.fontS,
    ),
    prefixIconColor: AppColors.textSecondary,
    suffixIconColor: AppColors.textSecondary,
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: AppSizes.fontL,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: AppSizes.fontL,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: AppSizes.fontM,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: AppColors.white,
    elevation: 2,
    shadowColor: AppColors.black.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
    ),
  ),

  // Radio Theme
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.grey400;
    }),
  ),

  // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.white),
    side: const BorderSide(color: AppColors.grey400, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusXS),
    ),
  ),

  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.grey400;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryLight;
      }
      return AppColors.grey200;
    }),
  ),

  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 1,
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),

  // Text Theme
  textTheme: TextTheme(
    displayLarge: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.roboto(
      color: AppColors.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.roboto(
      color: AppColors.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.roboto(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: GoogleFonts.roboto(
      color: AppColors.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  ),
);
