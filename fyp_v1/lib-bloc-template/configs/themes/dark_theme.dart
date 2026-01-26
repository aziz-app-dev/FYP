import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/color.dart';
import '../constants/app_sizes.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  // App Bar Theme
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.textWhite,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.textWhite),
    titleTextStyle: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: AppSizes.fontTitle,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Color Scheme
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.black,
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.secondaryLight,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textWhite,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.grey700,
  ),

  // Scaffold
  scaffoldBackgroundColor: AppColors.backgroundDark,
  primaryColor: AppColors.primary,

  // Text Selection
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: AppColors.primaryDark,
    selectionHandleColor: AppColors.primary,
  ),

  // Progress Indicator
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: AppColors.grey700,
    color: AppColors.primary,
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSizes.paddingM,
      vertical: AppSizes.paddingM,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.grey700),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: const BorderSide(color: AppColors.grey700),
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
      color: AppColors.grey400,
      fontSize: AppSizes.fontM,
    ),
    hintStyle: GoogleFonts.roboto(
      color: AppColors.grey500,
      fontSize: AppSizes.fontM,
    ),
    errorStyle: GoogleFonts.roboto(
      color: AppColors.error,
      fontSize: AppSizes.fontS,
    ),
    helperStyle: GoogleFonts.roboto(
      color: AppColors.grey400,
      fontSize: AppSizes.fontS,
    ),
    prefixIconColor: AppColors.grey400,
    suffixIconColor: AppColors.grey400,
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
      foregroundColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.primaryLight),
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
      foregroundColor: AppColors.primaryLight,
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
    color: AppColors.surfaceDark,
    elevation: 2,
    shadowColor: AppColors.black.withValues(alpha: 0.3),
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
      return AppColors.grey500;
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
    side: const BorderSide(color: AppColors.grey500, width: 2),
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
      return AppColors.grey500;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryDark;
      }
      return AppColors.grey700;
    }),
  ),

  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: AppColors.grey700,
    thickness: 1,
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundDark,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.grey500,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),

  // Text Theme
  textTheme: TextTheme(
    displayLarge: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.roboto(
      color: AppColors.grey400,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.roboto(
      color: AppColors.grey400,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.roboto(
      color: AppColors.textWhite,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: GoogleFonts.roboto(
      color: AppColors.grey400,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.roboto(
      color: AppColors.grey500,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  ),
);
