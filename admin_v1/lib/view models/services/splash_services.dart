import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/res/routes/routes_name.dart';

/// Decides where the app starts:
///  - no token            -> Login
///  - token + Admin       -> Admin home
///  - token + other role  -> wipe storage, Login (this app is admin-only)
class SplashServices {
  static void isLogin() {
    final box = GetStorage();
    final String? token = box.read('token');
    final String? userType = box.read('userType');

    Timer(const Duration(seconds: 2), () {
      if (token == null || token.isEmpty) {
        Get.offAllNamed(RouteName.LoginScreen);
      } else if (userType == 'Admin') {
        Get.offAllNamed(RouteName.adminHome);
      } else {
        box.erase();
        Get.offAllNamed(RouteName.LoginScreen);
      }
    });
  }
}
