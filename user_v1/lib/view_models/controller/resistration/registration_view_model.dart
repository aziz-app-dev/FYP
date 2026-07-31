import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/success/success_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

class RegistrationController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  void registrationFunction(String data) async {
    setLoading = true;
    Uri url = Uri.parse('${AppUrl.baseUrl}/register');
    Map<String, String> headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        var data = successModelFromJson(response.body);

        setLoading = false;

        Utils.showSuccess(
          'You are successfully registered',
          data.message,
          icon: const Icon(Ionicons.fast_food_outline),
        );

        // Navigate to loginScreen
        Get.toNamed(RouteName.LoginScreen);
      } else {
        setLoading = false;
        var error = errorModelFromJson(response.body);

        Utils.showError(
          'Failed to register',
          error.message,
        );
      }
    } catch (e) {
      setLoading = false;
      debugPrint(e.toString());
    }
  }
}
