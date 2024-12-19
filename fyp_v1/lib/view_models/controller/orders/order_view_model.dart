import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/order/order_response_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/routes/routes_name.dart';

class OrderController extends GetxController {
  final box = GetStorage();

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> createOrder(var data) async {
    setLoading = true;

    String accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/order');

      final response = await http.post(url, headers: headers, body: data);

      setLoading = false;

      if (response.statusCode == 201) {
        OrderResponseModel data = orderResponseModelFromJson(response.body);

        // String orderId = data.orderId;

        Get.snackbar('${data.message}!', 'Enjoy your awesome experience',
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.toNamed(RouteName.mainScreen);
      } else {
        var error = errorModelFromJson(response.body);
        Get.snackbar("Failed to place order", " ${error.message}",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
    } catch (e) {
      Get.snackbar('Error', "Exception: ${e.toString()}",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline));
    } finally {
      setLoading = false;
    }
  }

// ! Cancel the order
  Future<void> cancelOrder(String orderId, Function refetch) async {
    setLoading = true;
    String accessToken =
        box.read("token"); // Ensure 'box' is defined or imported
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/order/$orderId');
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(<String, String>{
          'orderStatus': 'Cancelled',
        }),
      );

      if (response.statusCode == 200) {
        setLoading = false;
        refetch(); // Refresh the order list after successful cancellation
        Get.snackbar(
          "Order Cancelled successfully!",
          "Enjoy the awesome experience",
          colorText: kLightWhite,
          backgroundColor: kPrimary,
          icon: const Icon(Ionicons.fast_food_outline),
        );
      } else {
        var responseBody = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          responseBody['message'],
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline),
        );
      }
    } catch (e) {
      // print(e);
      Get.snackbar(
        "Error",
        "An error occurred while cancelling the order",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error_outline),
      );
    } finally {
      setLoading = true;
    }
  }
}
