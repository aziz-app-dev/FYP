import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/config.dart';

class OnboardingPageThree extends StatefulWidget {
  const OnboardingPageThree({super.key});

  @override
  State<OnboardingPageThree> createState() => _OnboardingPageThreeState();
}

class _OnboardingPageThreeState extends State<OnboardingPageThree>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
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

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _mainController.forward();
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
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
          colors: [
            AppColors.onboardingBg3Start,
            AppColors.onboardingBg3Mid,
            AppColors.onboardingBg3End,
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Background decorations
            _buildBackgroundDecorations(),
            // Confetti effect
            _buildConfettiEffect(),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20.spMin),
                // Celebration visual
                Flexible(
                  fit: FlexFit.loose,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildCelebrationVisual(),
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

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Large decorative circles
        Positioned(
          top: -100.h,
          right: -80.w,
          child: Container(
            width: 250.w,
            height: 250.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 50.h,
          left: -100.w,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ),
        // Rounded rectangle accents
        Positioned(
          top: 150.h,
          right: -30.w,
          child: Transform.rotate(
            angle: 0.3,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.tertiary.withValues(alpha: 0.08),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfettiEffect() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final random = math.Random(index);
            final startX = random.nextDouble() * 400.w;
            final delay = random.nextDouble();
            final progress = (_confettiController.value + delay) % 1.0;
            final yPosition = -50.h + (progress * 900.h);
            final xOffset = math.sin(progress * math.pi * 2 + index) * 30.w;
            final rotation = progress * math.pi * 4;
            final opacity = progress < 0.8 ? 1.0 : (1.0 - progress) * 5;

            return Positioned(
              left: startX + xOffset,
              top: yPosition,
              child: Opacity(
                opacity: opacity.clamp(0.0, 0.6),
                child: Transform.rotate(
                  angle: rotation,
                  child: _buildConfettiPiece(index),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildConfettiPiece(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      AppColors.secondaryAccent,
    ];
    final color = colors[index % colors.length];
    final shapes = [
      Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
      Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      Container(
        width: 12.w,
        height: 6.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    ];
    return shapes[index % shapes.length];
  }

  Widget _buildCelebrationVisual() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Stacked cards effect behind main card
        Positioned(
          child: Transform.rotate(
            angle: 0.15,
            child: Transform.translate(
              offset: Offset(20.w, 10.h),
              child: _buildBackCard(
                AppColors.secondaryAccent.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        Positioned(
          child: Transform.rotate(
            angle: -0.1,
            child: Transform.translate(
              offset: Offset(-15.w, 5.h),
              child: _buildBackCard(AppColors.primary.withValues(alpha: 0.4)),
            ),
          ),
        ),
        // Main card
        ScaleTransition(scale: _bounceAnimation, child: _buildMainCard()),
        // // Floating badges
        // Positioned(
        //   top: 20.h,
        //   right: 40.w,
        //   child: _buildRewardBadge(),
        // ),
        // Positioned(
        //   bottom: 40.h,
        //   left: 30.w,
        //   child: _buildDiscountBadge(),
        // ),
        Positioned(top: 10.h, left: 10.w, child: _buildStarBadge()),
      ],
    );
  }

  Widget _buildBackCard(Color color) {
    return Container(
      width: 180.h,
      height: 210.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24.r),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: 200.h,
      height: 250.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.spMin),
                child: Image.asset(
                  AppImages.onboarding3Main,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Bottom section with CTA
          Container(
            padding: EdgeInsets.only(
              bottom: 16.spMin,
              left: 16.spMin,
              right: 16.spMin,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.spMin),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                spacing: 8.spMin,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: AppColors.textOnPrimary,
                    size: 18.spMin,
                  ),
                  Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 15.spMin,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRewardBadge() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  //     decoration: BoxDecoration(
  //       color: AppColors.surface,
  //       borderRadius: BorderRadius.circular(16.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.tertiary.withValues(alpha: 0.2),
  //           blurRadius: 12,
  //           spreadRadius: 2,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(4.w),
  //           decoration: BoxDecoration(
  //             color: AppColors.tertiary.withValues(alpha: 0.15),
  //             borderRadius: BorderRadius.circular(6.r),
  //           ),
  //           child: Icon(
  //             Icons.card_giftcard,
  //             color: AppColors.tertiary,
  //             size: 16.spMin,
  //           ),
  //         ),
  //         SizedBox(width: 6.w),
  //         Text(
  //           'Rewards',
  //           style: TextStyle(
  //             fontSize: 12.spMin,
  //             fontWeight: FontWeight.w600,
  //             color: AppColors.tertiary,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDiscountBadge() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [AppColors.primary, AppColors.primaryDark],
  //       ),
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.primary.withValues(alpha: 0.3),
  //           blurRadius: 10,
  //           spreadRadius: 1,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           '50%',
  //           style: TextStyle(
  //             fontSize: 14.spMin,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textOnPrimary,
  //           ),
  //         ),
  //         SizedBox(width: 4.w),
  //         Text(
  //           'OFF',
  //           style: TextStyle(
  //             fontSize: 10.spMin,
  //             fontWeight: FontWeight.w600,
  //             color: AppColors.textOnPrimary.withValues(alpha: 0.8),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStarBadge() {
    return Container(
      padding: EdgeInsets.all(10.spMin),
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.star.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.star, color: AppColors.star, size: 22.spMin),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.spMin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature pills
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeaturePill(Icons.bolt, 'Fast'),
              SizedBox(width: 8.w),
              _buildFeaturePill(Icons.verified, 'Safe'),
              SizedBox(width: 8.w),
              _buildFeaturePill(Icons.favorite, 'Tasty'),
            ],
          ),
          SizedBox(height: 24.spMin),
          // Main title with gradient
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.secondaryDark, AppColors.primary],
            ).createShader(bounds),
            child: Text(
              'Start Your Food Journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.spMin,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: 16.spMin),
          // Description
          Text(
            'Join millions of food lovers. Get exclusive deals, earn rewards, and enjoy delicious meals!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.spMin,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.spMin),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 6.spMin),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondary, size: 14.spMin),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.spMin,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
