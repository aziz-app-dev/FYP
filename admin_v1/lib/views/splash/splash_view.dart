import 'package:flutter/material.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../view models/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SplashServices.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kWhite.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: kWhite,
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            const ReuseableText(
              text: 'FYP Super Admin',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              textColor: kWhite,
            ),
            const SizedBox(height: 6),
            const ReuseableText(
              text: 'Orders • Restaurants • Users',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor: kLightWhite,
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: kWhite,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
