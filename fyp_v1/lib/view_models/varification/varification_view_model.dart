import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/error/error_model.dart';
import '../../models/login/login_respose_model.dart';
import '../../res/app_url/app_url.dart';
import '../../utils/utils.dart';
import '../../view/user/main/main_view.dart';

class VarificationController extends GetxController {
  final box = GetStorage();
// ! code
  String _code = '';

  String get code => _code;

  set setCode(String value) {
    _code = value;
  }

// ! loading
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  // ! login function

  void varificationFunction() async {
    String accessToken = box.read("token");
    setLoading = true;
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/user/varify/$code');
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

        Utils.showSuccess(
          'You are successfully verified',
          'Enjoy your awesome experience',
          icon: const Icon(Ionicons.fast_food_outline),
        );

        Get.offAll(const MainScreen());
      } else {
        var error = errorModelFromJson(response.body);
        Utils.showError('Failed to verify Account', error.message);
      }
      // ! error
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
