import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/config.dart';

class OnboardingPageTwo extends StatefulWidget {
  const OnboardingPageTwo({super.key});

  @override
  State<OnboardingPageTwo> createState() => _OnboardingPageTwoState();
}

class _OnboardingPageTwoState extends State<OnboardingPageTwo>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _mainController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.tertiary, AppColors.tertiaryDark],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements
            _buildBackgroundDecoration(),

            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.spMin),
                // Tracking visualization
                Flexible(
                  fit: FlexFit.loose,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(child: _buildTrackingVisualization()),
                  ),
                ),
                // Text content
                Flexible(
                  fit: FlexFit.loose,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildTextContent(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Stack(
      children: [
        // Top right glow
        Positioned(
          top: -50.h,
          right: -50.w,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.tertiaryLight.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom left glow
        Positioned(
          bottom: 90.h,
          left: -80.w,
          child: Container(
            width: 180.w,
            height: 180.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Floating dots
        Positioned(
          top: 120.h,
          left: 40.w,
          child: _buildFloatingDot(
            8.spMin,
            AppColors.secondary.withValues(alpha: 0.5),
          ),
        ),
        Positioned(
          top: 200.h,
          right: 60.w,
          child: _buildFloatingDot(
            6.spMin,
            AppColors.primary.withValues(alpha: 0.4),
          ),
        ),
        Positioned(
          bottom: 250.h,
          left: 80.w,
          child: _buildFloatingDot(
            10.spMin,
            AppColors.tertiaryLight.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildTrackingVisualization() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring with dashes (route path)
        Container(
          width: 320.spMin,
          height: 320.spMin,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.surface.withValues(alpha: 0.15),
              width: 2,
            ),
          ),
        ),
        // Middle ring
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 220.spMin,
                height: 220.spMin,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
              ),
            );
          },
        ),
        // Main image container with gradient border
        Container(
          width: 190.spMin,
          height: 190.spMin,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.secondary, AppColors.primary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: EdgeInsets.all(4.spMin),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.tertiaryDark,
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(10.spMin),
                child: Image.asset(AppImages.onboarding2, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        // Location markers on the path
        Positioned(
          top: 20.spMin,
          right: 70.spMin,
          child: _buildLocationMarker(isStart: true),
        ),
        Positioned(
          bottom: 30.spMin,
          left: 20.spMin,
          child: _buildLocationMarker(isStart: false),
        ),
        // Timer badge
        Positioned(top: 30.spMin, left: 2.spMin, child: _buildTimeBadge()),
        // Live tracking badge
        Positioned(bottom: 40.spMin, right: 20.spMin, child: _buildLiveBadge()),
        // Delivery person indicator
        Positioned(
          right: 10.spMin,
          top: 100.spMin,
          child: _buildDeliveryIndicator(),
        ),
      ],
    );
  }

  Widget _buildLocationMarker({required bool isStart}) {
    return Container(
      padding: EdgeInsets.all(8.spMin),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: [
          BoxShadow(
            color: isStart
                ? AppColors.secondary.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Image.asset(
        isStart ? AppImages.shopIcon : AppImages.homeIcon,
        height: 20.spMin,
        width: 20.spMin,
      ),
    );
  }

  Widget _buildTimeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.spMin, vertical: 6.spMin),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.spMin),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Image.asset(
              AppImages.clockIcon,
              height: 20.spMin,
              width: 20.spMin,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '25 min',
            style: TextStyle(
              fontSize: 13.spMin,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 6.spMin),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.spMin,
            height: 8.spMin,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.surface.withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'LIVE',
            style: TextStyle(
              fontSize: 11.spMin,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryIndicator() {
    return Container(
      padding: EdgeInsets.all(7.spMin),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Image.asset(
        AppImages.deliveryIcon,
        height: 26.spMin,
        width: 26.spMin,
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.gps_fixed,
                  color: AppColors.secondary,
                  size: 14.spMin,
                ),
                SizedBox(width: 6.w),
                Text(
                  'REAL-TIME TRACKING',
                  style: TextStyle(
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.spMin),
          // Main title
          Text(
            'Track Your Order Live',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.spMin,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.spMin),
          // Description
          Text(
            'Watch your food journey from restaurant to your door with real-time GPS tracking.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.spMin,
              color: AppColors.textOnPrimary.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.spMin),
        ],
      ),
    );
  }
}
