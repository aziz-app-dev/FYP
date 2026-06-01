import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../res/routes/routes_name.dart';

class SplashServices {
  void splash() {
    final box = GetStorage();
    String? token = box.read('token');
    if (kDebugMode) {
      print('token splash : $token');
    }
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(RouteName.mainScreen);
    });
  }
}
