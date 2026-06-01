import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/error/error_model.dart';
import '../../models/login/login_respose_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/routes/routes_name.dart';

class PhoneVarificationController extends GetxController {
  final box = GetStorage();
// ! code
  String _phone = '';

  String get phone => _phone;

  set setPhoneNumber(String value) {
    _phone = value;
  }

// ! loading
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  // ! verify phone function

  void verifyPhone() async {
    String accessToken = box.read("token");
    setLoading = true;
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/user/varify-phone/$phone');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );

      // print(response.body);
      // !
      if (response.statusCode == 200) {
        LoginResponseModel data = loginResponseModelFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);

        // !610258
        box.write(userId, userData);
        box.write('token', data.userToken);
        box.write('userId', data.id);
        box.write('verification', data.verification);

        setLoading = false;
        // ! snackbar
        Get.snackbar(
            'Your are successfully verified', 'Enjoy your awesome experience',
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.back();
      } else {
        // !  error
        var error = errorModelFromJson(response.body);
        Get.snackbar('Failed to verify Account', error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
      // ! error
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //! verify phone function with phone number
  void verifyPhone2(String phoneNumber) async {
    String? accessToken = box.read("token");
    if (accessToken == null) {
      Get.snackbar(
        'Error',
        'Access token is missing',
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error_outline),
      );
      return;
    }

    setLoading = true;
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/user/varify-phone/$phoneNumber');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );

      // print(response.body);

      if (response.statusCode == 200) {
        LoginResponseModel data = loginResponseModelFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);

        box.write(userId, userData);
        box.write('token', data.userToken);
        box.write('userId', data.id);
        box.write('verification', data.verification);

        setLoading = false;

        Get.snackbar(
          'You are successfully verified',
          'Enjoy your awesome experience',
          colorText: kLightWhite,
          backgroundColor: kPrimary,
          icon: const Icon(Ionicons.fast_food_outline),
        );

        Get.toNamed(RouteName.mainScreen);
      } else {
        var error = errorModelFromJson(response.body);
        Get.snackbar(
          'Failed to verify Account',
          error.message,
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading = false;
    }
  }
}
