import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/success/success_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/routes/routes_name.dart';

class RegistrationController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

// !
  void registrationFunction(String data) async {
    setLoading = true;
    Uri url = Uri.parse('${AppUrl.baseUrl}/register');
    Map<String, String> headers = {'Content-Type': 'application/json'};

// !
    try {
      var response = await http.post(url, headers: headers, body: data);

      // print(response.statusCode);

      if (response.statusCode == 201) {
        var data = successModelFromJson(response.body);

        setLoading = false;
// !
        Get.snackbar('Your are successfully registered', data.message,
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        // Navigate to loginScreen
        Get.toNamed(RouteName.LoginScreen);
      } else {
        // print(response.statusCode);
        var error = errorModelFromJson(response.body);
        // !
        // print(error.message);
        Get.snackbar('Failed to registration', error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
    } catch (e) {
      // print(e);
      debugPrint(e.toString());
    }
  }
}
