import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/user/onbording/onbording_bloc.dart';
import '../../../../bloc/user/onbording/onbording_event.dart';
import '../../../../bloc/user/onbording/onbording_state.dart';
import '../../../../config/config.dart';
import '../../../../di/service_locator.dart';
import '../../../../routes/route_name.dart';
import '../../../../services/session/session_manger.dart';

import 'onboarding_page_one.dart';
import 'onboarding_page_two.dart';
import 'onboarding_page_three.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  // Bloc instance created in initState
  late OnbordingBloc _onboardingBloc;

  final List<Widget> _pages = const [
    OnboardingPageOne(),
    OnboardingPageTwo(),
    OnboardingPageThree(),
  ];

  final List<Color> _indicatorColors = const [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
  ];

  final List<Color> _buttonColors = const [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
  ];

  @override
  void initState() {
    super.initState();

    _onboardingBloc = getIt<OnbordingBloc>();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _nextPage() {
    final currentIndex = _onboardingBloc.state.index;

    if (currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _skipOnboarding() {
    _navigateToAuth();
  }

  Future<void> _navigateToAuth() async {
    await SessionManager().completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteName.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    _onboardingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnbordingBloc>.value(
      value: _onboardingBloc,
      child: Scaffold(
        body: Stack(
          children: [
            // ── PageView ────────────────────────────────────────────────
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _onboardingBloc.add(IndexChage(index: index));
              },
              children: _pages,
            ),

            // ── Bottom navigation ───────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.spMin,
                  vertical: 20.spMin,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
                child: BlocBuilder<OnbordingBloc, OnbordingState>(
                  builder: (context, state) {
                    final currentPage = state.index;
                    final isDarkPage = currentPage == 1;
                    final isLastPage = currentPage == _pages.length - 1;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSkipButton(isDarkPage),
                        _buildPageIndicators(currentPage, isDarkPage),
                        _buildNextButton(isLastPage),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(bool isDarkPage) {
    return TextButton(
      onPressed: _skipOnboarding,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.spMin, vertical: 8.spMin),
      ),
      child: Text(
        'Skip',
        style: TextStyle(
          fontSize: 15.spMin,
          fontWeight: FontWeight.w500,
          color: isDarkPage
              ? AppColors.textOnPrimary.withValues(alpha: 0.75)
              : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPageIndicators(int currentPage, bool isDarkPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: currentPage == index ? 28.spMin : 8.spMin,
          height: 8.spMin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: currentPage == index
                ? _indicatorColors[currentPage]
                : (isDarkPage
                      ? AppColors.surface.withValues(alpha: 0.35)
                      : AppColors.textHint.withValues(alpha: 0.35)),
            boxShadow: currentPage == index
                ? [
                    BoxShadow(
                      color: _indicatorColors[currentPage].withValues(
                        alpha: 0.45,
                      ),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(bool isLastPage) {
    // Use the bloc field directly — no context.watch needed here
    final currentPage = _onboardingBloc.state.index;

    return GestureDetector(
      onTapDown: (_) => _buttonAnimationController.forward(),
      onTapUp: (_) {
        _buttonAnimationController.reverse();
        _nextPage();
      },
      onTapCancel: () => _buttonAnimationController.reverse(),
      child: ScaleTransition(
        scale: _buttonScaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: isLastPage ? 24.spMin : 18.spMin,
            vertical: 12.spMin,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _buttonColors[currentPage],
                currentPage == 0
                    ? AppColors.primaryDark
                    : currentPage == 1
                    ? AppColors.secondaryDark
                    : AppColors.tertiaryDark,
              ],
            ),
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: _buttonColors[currentPage].withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLastPage ? 'Get Started' : 'Next',
                style: TextStyle(
                  fontSize: 15.spMin,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnPrimary,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                isLastPage ? Icons.rocket_launch : Icons.arrow_forward,
                color: AppColors.textOnPrimary,
                size: 18.spMin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
