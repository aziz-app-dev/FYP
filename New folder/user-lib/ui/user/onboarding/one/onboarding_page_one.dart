import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/utils.dart';
import '../../../../config/config.dart';

class OnboardingPageOne extends StatefulWidget {
  const OnboardingPageOne({super.key});

  @override
  State<OnboardingPageOne> createState() => _OnboardingPageOneState();
}

class _OnboardingPageOneState extends State<OnboardingPageOne>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.onboardingBg1,
            AppColors.onboardingBg1End,
            AppColors.surface,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 50.spMin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cuisine grid section
              Flexible(
                fit: FlexFit.loose,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildCuisineShowcase(),
                  ),
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
        ),
      ),
    );
  }

  Widget _buildCuisineShowcase() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background decorative circles
        Positioned(
          top: 20.h,
          left: 30.w,
          child: _buildDecorativeCircle(
            80.spMin,
            AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        Positioned(
          bottom: 40.spMin,
          right: 20.spMin,
          child: _buildDecorativeCircle(
            60.spMin,
            AppColors.secondary.withValues(alpha: 0.2),
          ),
        ),
        Positioned(
          top: 80.spMin,
          right: 50.spMin,
          child: _buildDecorativeCircle(
            40.spMin,
            AppColors.tertiary.withValues(alpha: 0.1),
          ),
        ),

        // Main circular image container
        Container(
          width: 370.spMin,
          height: 370.spMin,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.2),
                AppColors.secondary.withValues(alpha: 0.15),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 280.spMin,
              height: 280.spMin,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: EdgeInsets.all(10.spMin),
                  child: Image.asset(
                    AppImages.onboarding1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Floating cuisine cards
        Positioned(
          top: ScreenUtils.isMobile(context) ? 10.spMin : 100.h,
          right: 30.spMin,
          child: _buildCuisineCard(
            icon: Icons.local_pizza,
            label: 'Pizza',
            img: AppImages.pizzaIcon,
            color: AppColors.primary,
            rotation: 0.1,
          ),
        ),
        Positioned(
          top: 60.spMin,
          left: 20.spMin,
          child: _buildCuisineCard(
            icon: Icons.ramen_dining,
            img: AppImages.noodlesIcon,
            label: 'Asian',
            color: AppColors.secondary,
            rotation: -0.08,
          ),
        ),
        Positioned(
          bottom: 60.spMin,
          right: 5.spMin,
          child: _buildCuisineCard(
            icon: Icons.lunch_dining,
            img: AppImages.hamburgerIcon,
            label: 'Burger',
            color: AppColors.tertiary,
            rotation: 0.09,
          ),
        ),
        Positioned(
          bottom: 70.spMin,
          left: 15.spMin,
          child: _buildCuisineCard(
            icon: Icons.icecream,
            img: AppImages.iceCreamIcon,

            label: 'Dessert',
            color: AppColors.secondaryAccent,
            rotation: -0.16,
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size.spMin,
      height: size.spMin,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildCuisineCard({
    required IconData icon,
    required String? img,
    required String label,
    required Color color,
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 8.spMin),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: AppSizes.radiusMd,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.spMin),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: img!.isNotEmpty
                  ? Image.asset(img, height: 20.spMin, width: 20.spMin)
                  : Icon(icon, color: color, size: 18.spMin),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.spMin,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.spMin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.spMin,
              vertical: 6.spMin,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore, color: AppColors.primary, size: 16.spMin),
                SizedBox(width: 6.spMin),
                Text(
                  'EXPLORE',
                  style: TextStyle(
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.spMin),
          // Main title with gradient
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ).createShader(bounds),
            child: Text(
              'Discover Delicious Food',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.spMin,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: 16.spMin),
          // Description
          Text(
            'Browse through hundreds of cuisines from local favorites to international delights.',
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
}
