import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../models/cart/cart_count_model.dart';
import '../../../models/error/error_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/general_exception.dart';

class CartController extends GetxController {
  final box = GetStorage();
  final RxBool _isLoading = false.obs;
  final RxInt _count = 0.obs;

  int get count => _count.value;

  set setCount(int value) {
    _count.value = value;
  }

  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

// ! add to cart api call
  void addToCart(var cart) async {
    setLoading = true;

    // await Future.delayed(Duration(seconds: 2));
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/cart/');

    String accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      var response = await http.post(url, headers: headers, body: cart);
      if (response.statusCode == 201) {
        fetchCartCount();
        setLoading = false;

        Get.snackbar('Add to cart', 'Enjoy your awesome experience',
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(
              Icons.done_outline_rounded,
              color: Colors.white,
            ));
      } else {
        // !  error
        setLoading = false;
        var error = errorModelFromJson(response.body);
        Get.snackbar('Failed to add to cart', error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
      // } on SocketException {
      //   Get.to(() => const InterNetExceptionWidget());
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      setLoading = false;
      Get.snackbar('Error', e.toString(),
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline));
      Get.to(() => const GeneralExceptionWidget());
    } finally {
      setLoading = false;
    }
  }

  // ! remove item from cart
  void removeToCart(var productId, Function refetch) async {
    setLoading = true;

    // await Future.delayed(Duration(seconds: 2));
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/cart/delete/$productId');

    String accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      var response = await http.delete(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        setLoading = false;
        // print('statusCode:${response.statusCode}');
        refetch();
        fetchCartCount();
        Get.snackbar('Delete from cart', 'Enjoy your awesome experience',
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(
              Icons.done_outline_rounded,
              color: Colors.white,
            ));
      } else {
        // !  error
        setLoading = false;
        var error = errorModelFromJson(response.body);
        Get.snackbar('Failed to add to cart', error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
      // } on SocketException {
      //   Get.to(() => const InterNetExceptionWidget());
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      setLoading = false;
      Get.snackbar('Failed to login', e.toString(),
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline));
    } finally {
      setLoading = false;
    }
  }
  // !

  // Method to fetch cart count from the API
  Future<void> fetchCartCount() async {
    setLoading = true;

    // await Future.delayed(Duration(seconds: 2));
    Uri url = Uri.parse('${AppUrl.baseUrl}/api/cart/count');

    String? accessToken = box.read("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      // Replace with your actual API endpoint
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Parse the response and update the cartCountModel
        var cartCounts = cartCountModelFromJson(response.body);
        // print(response.body);
        // print(response.statusCode);
        setCount = cartCounts.cartCount;
        // print('controller cart count :$count');
      }
      // } on SocketException {
      //   Get.to(() => const InterNetExceptionWidget());
    } on http.ClientException {
      Get.to(() => const GeneralExceptionWidget());
    } catch (e) {
      setLoading = true;

      // Handle the exception
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      setLoading = true;
    }
  }
}
