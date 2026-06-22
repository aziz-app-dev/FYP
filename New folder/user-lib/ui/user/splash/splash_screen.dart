import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/config.dart';
import '../../../routes/route_name.dart';
import '../../../repo/user/settings/settings_repo.dart';
import '../../../services/background/background_data_service.dart';
import '../../../services/session/session_manger.dart';
import '../../../utils/loaders_utils.dart';

class SplashScreen extends StatefulWidget {
  final String entryPoint;

  const SplashScreen({super.key, this.entryPoint = 'user'});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkSessionAndNavigate();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoRotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _logoController.forward().then((_) {
      _textController.forward();
      _pulseController.repeat(reverse: true);
    });
  }

  Future<void> _checkSessionAndNavigate() async {
    // Load cached data from local storage (fast)
    final session = SessionManager();
    await session.loadSession();
    await session.loadSettings();

    debugPrint(
      'SplashScreen: isLoggedIn=${session.isLoggedIn}, '
      'userType=${session.user?.userType}, '
      'isAdmin=${session.isAdmin}, '
      'entryPoint=${widget.entryPoint}',
    );

    // Check if token is expired and logout if needed
    if (session.isLoggedIn) {
      final isExpired = await session.checkAndHandleTokenExpiration();
      if (isExpired) {
        debugPrint(
          'SplashScreen: Token expired, user will be redirected to login',
        );
      }
    }

    // Fetch fresh settings from API and wait for it (runs in parallel with animation)
    final settingsFuture = _fetchAndSaveSettings(session);
    final animationFuture = Future.delayed(const Duration(milliseconds: 3500));

    // Wait for both animation and settings fetch to complete
    await Future.wait([settingsFuture, animationFuture]);

    // Start background profile loading (doesn't block navigation)
    BackgroundDataService().loadAllBackgroundData();

    if (!mounted) return;

    // If user is logged in, route by their actual role regardless of entry point
    if (session.isLoggedIn && session.user != null) {
      final nextRoute = session.isAdmin
          ? RouteName.adminMain
          : session.isVendor
          ? RouteName.vendorDashboard
          : session.isDriver
          ? RouteName.driverMain
          : RouteName.mainScreen;
      debugPrint('SplashScreen: Navigating to $nextRoute');
      Navigator.pushReplacementNamed(context, nextRoute);
      return;
    }

    // Not logged in
    if (session.isFirstTime) {
      Navigator.pushReplacementNamed(context, RouteName.onboardingTwo);
    } else {
      Navigator.pushReplacementNamed(context, RouteName.login);
    }
  }

  Future<void> _fetchAndSaveSettings(SessionManager session) async {
    try {
      debugPrint('SplashScreen: Fetching settings from API...');
      final settings = await SettingsRepo().getSettings();
      await session.saveSettings(settings);
      debugPrint('SplashScreen: Settings fetched and saved');
    } catch (e) {
      debugPrint('SplashScreen: Error fetching settings: $e');
      // Falls back to cached settings loaded earlier
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          children: [
            _buildBackgroundDecorations(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //! Animated Logo
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoController,
                      _pulseController,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale:
                            _logoScaleAnimation.value * _pulseAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotateAnimation.value,
                          child: Opacity(
                            opacity: _logoFadeAnimation.value,
                            child: Container(
                              width: AppSizes.splashLogoSize,
                              height: AppSizes.splashLogoSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: AppSizes.shadowBlurXl,
                                    spreadRadius: AppSizes.shadowSpreadLg,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    AppSizes.splashLogoInnerPadding,
                                  ),
                                  child: Image.asset(
                                    AppImages.splashLogo,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AppSizes.verticalSpace3Xl,
                  //! Animated App Name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Column(
                            children: [
                              Text('Foodie', style: AppTextStyles.splashTitle),
                              AppSizes.verticalSpaceXs,
                              Text(
                                'Delicious food at your doorstep',
                                style: AppTextStyles.splashSubtitle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            //! Loading indicator at bottom
            Positioned(
              bottom: 80.h,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value,
                    child: Column(
                      children: [
                        appLoader(color: Colors.white, size: 50),
                        // SizedBox(
                        //   width: AppSizes.splashLoadingSize,
                        //   height: AppSizes.splashLoadingSize,
                        //   child: CircularProgressIndicator(
                        //     strokeWidth: 3,
                        //     valueColor: AlwaysStoppedAnimation<Color>(
                        //       AppColors.textOnPrimary.withValues(alpha: 0.8),
                        //     ),
                        //   ),
                        // ),
                        // AppSizes.verticalSpaceMd,
                        // Text('Loading...', style: AppTextStyles.splashLoading),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface.withValues(alpha: 0.05),
            ),
          ),
        ),
      ],
    );
  }
}
