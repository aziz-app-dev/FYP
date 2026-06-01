import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/rating/rating_response_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../utils/utils.dart';

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
        hasRated.value = false;
        Utils.showError("Error", error.message);
      }
    } catch (e) {
      hasRated.value = false;
      Utils.showError('Error', "Exception: ${e.toString()}");
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
        Utils.showSuccess(
          result.message.toString(),
          "Enjoy awesome experience",
          icon: const Icon(Ionicons.fast_food_outline),
        );
      } else {
        var error = errorModelFromJson(response.body);
        hasRated.value = false;
        Utils.showError("Error", error.message);
      }
    } catch (e) {
      Utils.showError("Error", e.toString());
    }
  }
}
