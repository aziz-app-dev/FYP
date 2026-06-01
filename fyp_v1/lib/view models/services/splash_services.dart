import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/res/routes/routes_name.dart';

/// Splash timing + auth-aware redirect for the vendor app.
///
/// - no token → LoginScreen
/// - token but wrong userType → wipe + LoginScreen
/// - valid vendor/admin token → vendorHome
class SplashServices {
  void splash() {
    final box = GetStorage();
    final String? token = box.read('token');
    final String? userType = box.read('userType');

    if (kDebugMode) {
      debugPrint('splash → token=$token, userType=$userType');
    }

    Timer(const Duration(seconds: 3), () {
      if (token == null || token.isEmpty) {
        Get.offAllNamed(RouteName.LoginScreen);
        return;
      }
      if (userType != 'Vendor' && userType != 'Admin') {
        box.erase();
        Get.offAllNamed(RouteName.LoginScreen);
        return;
      }
      Get.offAllNamed(RouteName.vendorHome);
    });
  }
}
