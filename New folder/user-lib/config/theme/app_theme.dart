import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_text_styles.dart';

/// Complete app theme configuration for the Food Delivery App
class AppTheme {
  AppTheme._();

  // ============== Light Theme ==============
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: AppSizes.appBarElevation,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconLg,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppSizes.cardElevation,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXl,
            vertical: AppSizes.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusRound),
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeightMd),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary,
            width: AppSizes.borderMedium,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXl,
            vertical: AppSizes.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          textStyle: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.primary,
          ),
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeightMd),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppSizes.borderMedium,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppSizes.borderMedium,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.textHint),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSizes.cardElevation,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        margin: EdgeInsets.all(AppSizes.marginXss),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primaryLight,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm,
          vertical: AppSizes.paddingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        labelStyle: AppTextStyles.chipText,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppSizes.cardElevationLg,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: AppSizes.cardElevationLg,
        selectedLabelStyle: TextStyle(
          fontSize: AppSizes.fontXs,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: AppSizes.fontXs),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: AppSizes.borderThin,
        space: AppSizes.spacingMd,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryLight,
        circularTrackColor: AppColors.primaryLight,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.tertiary,
        contentTextStyle: const TextStyle(color: AppColors.textOnPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXxl),
          ),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,

        labelStyle: TextStyle(
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: AppSizes.fontSm),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: AppSizes.iconLg,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.border;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        side: BorderSide(
          color: AppColors.primaryLight,
          width: AppSizes.borderMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),
    );
  }

  // ============== Dark Theme ==============
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryDark,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: AppColors.textDark,
        onError: AppColors.textOnPrimary,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: AppSizes.appBarElevation,
        centerTitle: true,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textDark,
        surfaceTintColor: Colors.transparent,
        //        SystemChrome.setSystemUIOverlayStyle(
        //   const SystemUiOverlayStyle(
        //     statusBarColor: Colors.transparent, // set the background color
        //     statusBarIconBrightness: Brightness.light, // icons color (Android)
        //     statusBarBrightness: Brightness.dark, // icons color (iOS)
        //   ),
        // );
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),

        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textDark,
          size: AppSizes.iconLg,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.textDark,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.textDark,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.textDark,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textDark,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textDark,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textDark,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textDark,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textDark,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textDark,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textDark,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textDark,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppSizes.cardElevation,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXl,
            vertical: AppSizes.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusRound),
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeightMd),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppSizes.borderMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
        prefixIconColor: AppColors.textSecondaryDark,
        suffixIconColor: AppColors.textSecondaryDark,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        margin: EdgeInsets.all(AppSizes.marginXs),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: AppSizes.borderThin,
        space: AppSizes.spacingMd,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: AppSizes.cardElevationLg,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textDark,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXxl),
          ),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textDark,
        size: AppSizes.iconLg,
      ),
    );
  }
}
