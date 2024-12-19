import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/rating/rating_response_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/colors/app_color.dart';

class RatingController extends GetxController {
  final box = GetStorage();
  RxBool isLoading = true.obs;
  RxBool hasRated = false.obs;
  RxDouble userRating = 0.0.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   checkUserRating();
  // }

  Future<void> checkRating(String restaurantId) async {
    Uri url = Uri.parse(
        '${AppUrl.baseUrl}/api/rating?product=$restaurantId&ratingType=Restaurant');
    String accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        RatingResponseModel? result = RatingResponseModel.fromJson(data);
        hasRated.value = result.status;
        // userRating.value = response['rating'];
      } else {
        var error = errorModelFromJson(response.body);
        // print(error.message);
        hasRated.value = false;
        Get.snackbar("Error", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
    } catch (e) {
      hasRated.value = false;
      // print('Error: $e');
      Get.snackbar('Error', "Exception: ${e.toString()}",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline));
    } finally {
      // Ensure that any loading state is properly reset
      isLoading.value = false;
    }
  }

  Future<void> submitRating(String restaurantId, var data) async {
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/rating');
    String accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      final response = await http.post(url, headers: headers, body: data);
      if (response.statusCode == 200) {
        var bodyResponse = jsonDecode(response.body);
        RatingResponseModel? result =
            RatingResponseModel.fromJson(bodyResponse);
        hasRated.value = result.status;
        Get.snackbar(result.message.toString(), "Enjoy awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));
      } else {
        var error = errorModelFromJson(response.body);
        // print(error.message);
        hasRated.value = false;
        Get.snackbar("Error", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
    } catch (e) {
      // print(e);
      Get.snackbar("Error", e.toString(),
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline));
    }
  }
}
