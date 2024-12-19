import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/colors/app_color.dart';

class AddressController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var address = <String, String>{}.obs;
  var placeId = ''.obs;
  final RxBool _isDefault = false.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;

  double get latitude => _latitude.value;

  set setLatitude(double value) {
    _latitude.value = value;
  }

  double get longitude => _longitude.value;

  set setLongitude(double value) {
    _longitude.value = value;
  }

  bool get isDefault => _isDefault.value;

  set setIsDefault(bool value) {
    _isDefault.value = value;
  }

  Future<void> getCurrentLocationAndFetchAddress() async {
    isLoading.value = true;
    try {
      Position position = await _getCurrentLocation();
      Map<String, String> addressData =
          await _getAddressFromCoordinates(position);
      address.value = addressData;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, String>> _getAddressFromCoordinates(
      Position position) async {
    Uri url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setLongitude = position.longitude;
      setLatitude = position.latitude;

      // print(
      //     '///////////////////////////////////////////////////////////////////////////////////////////////');
      // print(position.longitude);
      // print(position.latitude);

      String extractedPlaceId = data["place_id"].toString();
      placeId.value = extractedPlaceId;
//  30.7658205 lat
//  74.1259125 lon
      return {
        "addressLine1": data["display_name"] ?? "",
        "city": data["name"] ?? data["address"]["town"] ?? '',
        "district":
            data["address"]["suburb"] ?? data["address"]["county"] ?? "",
        "province": data["address"]["state"] ?? "",
        "postalCode": data["address"]["postcode"] ?? "",
        "country": data["address"]["country"] ?? "",
      };
    } else {
      throw 'Failed to load address';
    }
  }

  Future<void> uploadAddress(var data) async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/address/');

      String accessToken = box.read("token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await http.post(url, headers: headers, body: data);

      isLoading.value = false;

      if (response.statusCode == 201) {
        Get.snackbar('Your are address successfully added',
            'Enjoy your awesome experience',
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));
      } else {
        var error = errorModelFromJson(response.body);
        Get.snackbar("Failed to upload address", error.message,
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
      isLoading.value = false;
    }
  }
}
