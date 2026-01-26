// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/login/login_respose_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../view/user/main/main_view.dart';
import '../../../utils/utils.dart';
import '../account_switcher/account_switcher_controller.dart';

class LoginController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  // ! login function
  void loginFunction(String data) async {
    setLoading = true;
    Uri url = Uri.parse('${AppUrl.baseUrl}/login');
    Map<String, String> headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(url, headers: headers, body: data);
      // print(response.body);
      // !
      if (response.statusCode == 200) {
        LoginResponseModel data = loginResponseModelFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);
        // !
        box.write(userId, userData);
        box.write('token', data.userToken);
        box.write('userId', data.id);
        box.write('verification', data.verification);
        // !
        // String? token = box.read('token');

        // print('${data.userToken}: 000');
        // print('$token : 111');
        // print(data);

        setLoading = false;

        Utils.showSuccess(
          'You are successfully logged in',
          'Enjoy your awesome experience',
          icon: const Icon(Ionicons.fast_food_outline),
        );

        // Refresh account switcher to check vendor eligibility
        if (Get.isRegistered<AccountSwitcherController>()) {
          Get.find<AccountSwitcherController>().refreshEligibility();
        }

        if (data.verification == true) {
          Get.offAll(() => const MainScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 900));
        }
      } else {
        setLoading = false;
        var error = errorModelFromJson(response.body);

        Utils.showError(
          'Failed to login',
          error.message,
        );
      }
      // ! error
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ! logout
  void logout() {
    // Clear account switcher mode
    if (Get.isRegistered<AccountSwitcherController>()) {
      Get.find<AccountSwitcherController>().clearMode();
    }
    box.erase();
    Get.offAll(() => const MainScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 900));
  }

  // ! user info
  LoginResponseModel? getUserInfo() {
    String? userId = box.read('userId');
    String? data;
    if (userId != null) {
      data = box.read(userId.toString());
    }
    if (data != null) {
      return loginResponseModelFromJson(data);
    }
    return null;
  }
}
