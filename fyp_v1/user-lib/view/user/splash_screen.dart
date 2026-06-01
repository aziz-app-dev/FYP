import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../view_models/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    super.initState();
    splashScreen.splash();
    // String? token = box.read('token');
    // print('token in main app : $token');
  }

  @override
  Widget build(BuildContext context) {
    // String? token = box.read('token');
    // print('token in main app : $token');
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
          child: Text(
        'welcome_back'.tr,
        textAlign: TextAlign.center,
      )),
    );
  }
}
