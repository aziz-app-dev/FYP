import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/order/order_response_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

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

        Utils.showSuccess(
          '${data.message}!',
          'Enjoy your awesome experience',
          icon: const Icon(Ionicons.fast_food_outline),
        );

        Get.toNamed(RouteName.mainScreen);
      } else {
        var error = errorModelFromJson(response.body);
        Utils.showError("Failed to place order", error.message);
      }
    } catch (e) {
      Utils.showError('Error', "Exception: ${e.toString()}");
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
        Utils.showSuccess(
          "Order Cancelled successfully!",
          "Enjoy the awesome experience",
          icon: const Icon(Ionicons.fast_food_outline),
        );
      } else {
        var responseBody = jsonDecode(response.body);
        Utils.showError("Error", responseBody['message']);
      }
    } catch (e) {
      Utils.showError("Error", "An error occurred while cancelling the order");
    } finally {
      setLoading = false;
    }
  }
}
