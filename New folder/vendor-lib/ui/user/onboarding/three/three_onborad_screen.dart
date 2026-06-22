import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slider_button/slider_button.dart';

import '../../../../config/config.dart'; // Assuming this contains AppImages
import '../../../../bloc/user/onbording/onbording_bloc.dart';
import '../../../../bloc/user/onbording/onbording_event.dart';
import '../../../../bloc/user/onbording/onbording_state.dart';
import '../../../../di/service_locator.dart';
import '../../../../routes/route_name.dart';
import '../../../../services/session/session_manger.dart';

class OnboardingThreeScreen extends StatefulWidget {
  const OnboardingThreeScreen({super.key});

  @override
  State<OnboardingThreeScreen> createState() => _OnboardingThreeScreenState();
}

class _OnboardingThreeScreenState extends State<OnboardingThreeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  bool _isNavigating = false;
  late final AnimationController _arrowController;
  late final Animation<double> _arrowShift;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: AppImages.onboarding4,
      title: 'Exceptional Food,\nDelivered Fresh',
      subtitle:
          'Experience gourmet-quality meals prepared with care and delivered faster than ever — straight to your doorstep.',
    ),
    OnboardingData(
      image: AppImages.onboarding5,
      title: 'Master Chefs,\nLocal Kitchens',
      subtitle:
          'Our network of professional chefs brings restaurant-quality dining to your home, using only the freshest local ingredients.',
    ),
    OnboardingData(
      image: AppImages.onboarding6,
      title: 'Track & Enjoy\nYour Meal',
      subtitle:
          'Real-time tracking from kitchen to door. Know exactly when your culinary experience will arrive.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _arrowShift = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page, BuildContext context) {
    context.read<OnbordingBloc>().add(IndexChage(index: page));
  }

  Future<void> _navigateNextScreen() async {
    if (_isNavigating) return;
    _isNavigating = true;
    await SessionManager().completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteName.login);
    }
  }

  Future<void> _slideNext(int currentPage) async {
    if (currentPage < _pages.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      await _navigateNextScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider(
      create: (_) => getIt<OnbordingBloc>(),
      child: BlocBuilder<OnbordingBloc, OnbordingState>(
        builder: (context, state) {
          final currentPage = state.index;
          final bool isLastPage = currentPage == _pages.length - 1;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Full-screen background images (locked; slide via bottom bar)
                PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => _onPageChanged(page, context),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return Image.asset(_pages[index].image, fit: BoxFit.cover);
                  },
                ),

                // Bottom gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 320.spMin,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.15, 0.4, 0.80],
                      ),
                    ),
                  ),
                ),

                // Text content
                Positioned(
                  bottom: 140.spMin,
                  left: 32.spMin,
                  right: 32.spMin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          _pages[currentPage].title,
                          key: ValueKey<String>(_pages[currentPage].title),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          _pages[currentPage].subtitle,
                          key: ValueKey<String>(_pages[currentPage].subtitle),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Modern Bottom Bar
                Positioned(
                  bottom: 40.spMin,
                  left: 24.spMin,
                  right: 24.spMin,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        padding: EdgeInsets.all(10.spMin),
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          color: Colors.white,
                          size: 26.spMin,
                        ),
                      ),
                      SizedBox(width: 10.spMin),
                      Expanded(
                        child: SliderButton(
                          action: () async {
                            await _slideNext(currentPage);
                            return false;
                          },
                          buttonKey: ValueKey('slider_$currentPage'),
                          height: 56.spMin,
                          width: double.infinity,
                          radius: 40,
                          buttonSize: 48.spMin,
                          dismissThresholds: 0.6,
                          backgroundColor: Colors.white.withValues(alpha: 0.12),
                          buttonColor: colors.primary,
                          baseColor: Colors.white60,
                          highlightedColor: Colors.white,
                          shimmer: true,
                          alignLabel: const Alignment(0.5, 0),
                          label: Row(
                            spacing: 4.spMin,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLastPage
                                    ? 'Get Started'
                                    : 'Slide to Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.spMin,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _arrowShift,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_arrowShift.value, 0),
                                    child: child,
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12.spMin,
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15.spMin,
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18.spMin,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          icon: Icon(
                            Icons.shopping_cart_checkout_rounded,
                            color: Colors.white,
                            size: 22.spMin,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
