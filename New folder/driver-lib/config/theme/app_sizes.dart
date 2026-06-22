import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App sizes and dimensions for the Food Delivery App
class AppSizes {
  AppSizes._();

  // ============== Spacing ==============
  static double spacingXxs = 4.0;
  static double spacingXs = 8.0;
  static double spacingSm = 12.0;
  static double spacingMd = 15.0;
  static double spacingLg = 20.0;
  static double spacingXl = 25.0;
  static double spacingXxl = 32.0;
  static double spacing3Xl = 40.0;
  static double spacing4Xl = 48.0;
  static double spacing5Xl = 64.0;

  // ============== Padding ==============
  static double paddingXs = 8.0.spMin;
  static double paddingSm = 12.0.spMin;
  static double paddingMd = 16.0.spMin;
  static double paddingLg = 20.spMin;
  static double paddingXl = 24.spMin;
  static double paddingXxl = 32.spMin;
  static double paddingXxxl = 30.spMin;
  static double paddingScreen = 24.spMin;

  // ============== Margin ==============
  static double marginXss = 4.0;
  static double marginXs = 8.0;
  static double marginSm = 12.0;
  static double marginMd = 16.0;
  static double marginLg = 20.0;
  static double marginXl = 24.0;

  // ============== Border Radius ==============
  static double radiusXs = 4.0.r;
  static double radiusSm = 8.0.r;
  static double radiusMd = 10.0.r;
  static double radiusLg = 12.0.r;
  static double radiusXl = 14.0.r;
  static double radiusXxl = 16.0.r;
  static double radius3Xl = 18.0.r;
  static double radius3Xxl = 20.0.r;
  static double radiusRound = 30.0.r;
  static double radiusCircular = 100.0.r;
  static double radiusCard = radiusMd;

  // ============== Icon Sizes ==============
  static double iconXs = 16.0.spMin;
  static double iconSm = 18.0.spMin;
  static double iconMd = 20.0.spMin;
  static double iconLg = 24.0.spMin;
  static double iconXl = 28.0.spMin;
  static double iconXxl = 32.0.spMin;

  // ============== Button Sizes ==============
  static double buttonHeightSm = 36.0.h;
  static double buttonHeightMd = 44.0.h;
  static double buttonHeightLg = 52.0.h;
  static double buttonHeightXl = 56.0.h;
  static double buttonMinWidth = 120.0.h;

  // ============== Avatar/Image Sizes ==============
  static double avatarXs = 32.0;
  static double avatarSm = 40.0;
  static double avatarMd = 48.0;
  static double avatarLg = 64.0;
  static double avatarXl = 80.0;
  static double avatarXxl = 100.0;

  // ============== Card Sizes ==============
  static double cardElevation = 2.0;
  static double cardElevationLg = 8.0;

  // ============== Splash Screen Sizes ==============
  static double splashLogoSize = 180.h;
  static double splashLogoInnerPadding = 10.h;
  static double splashLoadingSize = 30.h;

  // ============== Onboarding Sizes ==============
  static double onboardingImageContainerOuter = 280.h;
  static double onboardingImageContainerInner = 220.h;
  static double onboardingImagePadding = 25.spMin;
  static double onboardingFloatingIconSize = 50.spMin;
  static double onboardingDotSize = 12.spMin;
  static double onboardingIndicatorHeight = 8.h;
  static double onboardingIndicatorWidthActive = 24.h;
  static double onboardingIndicatorWidthInactive = 8.h;

  // Onboarding Page 2
  static double onboarding2CircleOuter = 300.spMin;
  static double onboarding2CircleInner = 200.spMin;

  // Onboarding Page 3
  static double onboarding3CardWidth = 160.spMin;
  static double onboarding3CardHeight = 200.spMin;
  static double onboarding3MainCardWidth = 180.0.spMin;
  static double onboarding3MainCardHeight = 220.0.spMin;

  // ============== Font Sizes ==============
  static double fontXxs = 10.0.spMin;
  static double fontXs = 12.0.spMin;
  static double fontSm = 14.0.spMin;
  static double fontMd = 16.0.spMin;
  static double fontLg = 18.0.spMin;
  static double fontXl = 20.0.spMin;
  static double fontXxl = 22.0.spMin;
  static double font3Xl = 24.0.spMin;
  static double font4Xl = 26.0.spMin;
  static double font5Xl = 28.0.spMin;
  static double font6Xl = 32.0.spMin;
  static const double priceSymbolSizeRatio = 0.8;
  static const double priceFractionSizeRatio = 0.5;
  static const double priceFractionVerticalOffsetFactor = 0.35;

  // ============== Line Heights ==============
  static double lineHeightTight = 1.2;
  static double lineHeightNormal = 1.5;
  static double lineHeightRelaxed = 1.75;

  // ============== Letter Spacing ==============
  static double letterSpacingTight = -0.5;
  static double letterSpacingNormal = 0.0;
  static double letterSpacingWide = 1.0;
  static double letterSpacingWider = 2.0;
  static double letterSpacingWidest = 3.0;

  // ============== Border Width ==============
  static double borderThin = 1.0;
  static double borderMedium = 1.5;
  static double borderThick = 3.0;

  // ============== Shadow ==============
  static double shadowBlurSm = 10.0;
  static double shadowBlurMd = 15.0;
  static double shadowBlurLg = 20.0;
  static double shadowBlurXl = 30.0;
  static double shadowSpreadSm = 1.0;
  static double shadowSpreadMd = 2.0;
  static double shadowSpreadLg = 5.0;

  // ============== App Bar ==============
  static double appBarHeight = 56.0;
  static double appBarElevation = 0.0;

  // ============== Bottom Navigation ==============
  static double bottomNavHeight = 70.0.h;

  // ============== EdgeInsets Helpers ==============
  static EdgeInsets paddingAllXs = EdgeInsets.all(paddingXs.spMin);
  static EdgeInsets paddingAllSm = EdgeInsets.all(paddingSm.spMin);
  static EdgeInsets paddingAllMd = EdgeInsets.all(paddingMd.spMin);
  static EdgeInsets paddingAllLg = EdgeInsets.all(paddingLg.spMin);
  static EdgeInsets paddingAllXl = EdgeInsets.all(paddingXl.spMin);

  static EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: paddingMd,
  );
  static EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: paddingLg,
  );
  static EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: paddingXl.spMin,
  );
  static EdgeInsets paddingHorizontalXxxl = EdgeInsets.symmetric(
    horizontal: paddingXl.sp,
  );

  static EdgeInsets paddingHorizontalXxl = EdgeInsets.symmetric(
    horizontal: paddingXxl,
  );
  static EdgeInsets paddingHorizontalScreen = EdgeInsets.symmetric(
    horizontal: spacing3Xl,
  );

  static EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(
    vertical: paddingXs,
  );
  static EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(
    vertical: paddingSm,
  );
  static EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: paddingMd,
  );

  // ============== SizedBox Helpers ==============
  static SizedBox verticalSpaceXxs = SizedBox(height: spacingXxs.spMin);
  static SizedBox verticalSpaceXs = SizedBox(height: spacingXs.spMin);
  static SizedBox verticalSpaceSm = SizedBox(height: spacingSm.spMin);
  static SizedBox verticalSpaceMd = SizedBox(height: spacingMd.spMin);
  static SizedBox verticalSpaceLg = SizedBox(height: spacingLg.spMin);
  static SizedBox verticalSpaceXl = SizedBox(height: spacingXl.spMin);
  static SizedBox verticalSpaceXxl = SizedBox(height: spacingXxl.spMin);
  static SizedBox verticalSpace3Xl = SizedBox(height: spacing3Xl.spMin);

  static SizedBox horizontalSpaceXxs = SizedBox(width: spacingXxs);
  static SizedBox horizontalSpaceXs = SizedBox(width: spacingXs);
  static SizedBox horizontalSpaceSm = SizedBox(width: spacingSm);
  static SizedBox horizontalSpaceMd = SizedBox(width: spacingMd);
  static SizedBox horizontalSpaceLg = SizedBox(width: spacingLg);
  static SizedBox horizontalSpaceXl = SizedBox(width: spacingXl);
}
