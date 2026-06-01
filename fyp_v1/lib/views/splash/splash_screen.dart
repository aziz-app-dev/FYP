import 'package:flutter/material.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../view models/services/splash_services.dart';

/// Vendor splash screen — mirrors the user app's minimal splash:
/// solid primary background with a single centered "Welcome back" line.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splash = SplashServices();

  @override
  void initState() {
    super.initState();
    _splash.splash();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimary,
      body: Center(
        child: ReuseableText(
          text: 'Welcome back',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: kLightWhite,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
