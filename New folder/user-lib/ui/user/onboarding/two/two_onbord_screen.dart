import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/user/onbording/onbording_bloc.dart';
import '../../../../bloc/user/onbording/onbording_event.dart';
import '../../../../bloc/user/onbording/onbording_state.dart';
import '../../../../config/config.dart';
import '../../../../config/widgets/app_btn.dart';
import '../../../../di/service_locator.dart';
import '../../../../routes/route_name.dart';
import '../../../../services/session/session_manger.dart';

class OnboardingPageTwo extends StatefulWidget {
  const OnboardingPageTwo({super.key});

  @override
  State<OnboardingPageTwo> createState() => _OnboardingPageTwoState();
}

class _OnboardingPageTwoState extends State<OnboardingPageTwo> {
  final PageController _pageController = PageController();

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: AppImages.onboarding1,
      title: 'Craft Your Own\nCulinary Experience',
      subtitle: 'Choose fresh ingredients curated just for you.',
      labels: [
        // LabelData('Fresh Spinach', 0.25, 0.35),
        // LabelData('Boiled Beef', 0.65, 0.45),
      ],
    ),
    OnboardingData(
      image: AppImages.onboarding2,
      title: 'Ultra-Fast Delivery\nYou Can Trust',
      subtitle: 'A seamless journey from kitchen to doorstep.',
      labels: [
        // LabelData('Delivery Location', 0.5, 0.15)
      ],
    ),
    OnboardingData(
      image: AppImages.onboarding4,
      title: 'Exceptional Food,\nDelivered Effortlessly',
      subtitle: 'Premium meals, wherever you are.',
      labels: [
        // LabelData('Fast Delivered', 0.75, 0.15)
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onContinuePressed(int currentPage) {
    if (currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  Future<void> _navigateToAuth() async {
    await SessionManager().completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnbordingBloc>(),
      child: BlocBuilder<OnbordingBloc, OnbordingState>(
        builder: (context, state) {
          final currentPage = state.index;

          return Scaffold(
            body: Stack(
              children: [
                // Page View with images
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<OnbordingBloc>().add(IndexChage(index: index));
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: _pages[index]);
                  },
                ),

                // Skip button at top left
                Positioned(
                  top: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.spMin, top: 8.spMin),
                      child: TextButton(
                        onPressed: _navigateToAuth,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.25),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.spMin,
                            vertical: 8.spMin,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14.spMin,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom section with gradient and content
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white,
                          Colors.white,
                        ],
                        stops: const [0.0, 0.6, 0.9, 0.8],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                final fade = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.15),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: fade,
                                );
                              },
                              child: Text(
                                _pages[currentPage].title,
                                key: ValueKey('title_$currentPage'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28.spMin,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Subtitle
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                final fade = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.15),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: fade,
                                );
                              },
                              child: Text(
                                _pages[currentPage].subtitle,
                                key: ValueKey('subtitle_$currentPage'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.spMin,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(height: 32.spMin),
                            // Pagination dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 4.spMin,
                                  ),
                                  width: currentPage == index ? 8 : 6,
                                  height: currentPage == index ? 8 : 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentPage == index
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.spMin),
                            // Continue button
                            AppButton(
                              fontSize: 18.spMin,
                              height: 50,
                              width: double.infinity,
                              text: currentPage == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Continue',
                              onPressed: () => _onContinuePressed(currentPage),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          data.image,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),

        // Gradient overlay from bottom (for image fade)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.8),
                  Colors.white.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // Floating labels with dotted lines
        ...data.labels.map(
          (label) => Positioned(
            left: label.x * MediaQuery.sizeOf(context).width,
            top: label.y * MediaQuery.sizeOf(context).height,
            child: FloatingLabel(text: label.text),
          ),
        ),
      ],
    );
  }
}

class FloatingLabel extends StatelessWidget {
  final String text;

  const FloatingLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dotted line
        CustomPaint(size: const Size(40, 2), painter: DottedLinePainter()),
        const SizedBox(width: 8),
        // Label container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4;
    const dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Data models
class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final List<LabelData> labels;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.labels,
  });
}

class LabelData {
  final String text;
  final double x; // 0.0 to 1.0 (percentage of screen width)
  final double y; // 0.0 to 1.0 (percentage of screen height)

  LabelData(this.text, this.x, this.y);
}
