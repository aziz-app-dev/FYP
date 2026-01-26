import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../models/error/error_model.dart';
import '../../../models/user/user_info_model.dart';
import '../../../res/app_url/app_url.dart';
import '../../../utils/utils.dart';

class UserInformation extends GetxController {
  final box1 = GetStorage();
  // String? accessToken = box1.read("token");

  RxString? selectedImagePath = ''.obs;
  var imageUrl = ''.obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final ImagePicker _picker = ImagePicker();
  UserInformationModel? user;

  @override
  void onInit() {
    super.onInit();
    // Initialize accessToken in the onInit method
    fetchUserData();
  }

  // ! pickImage
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath!.value = pickedFile.path;
    } else {
      Utils.showWarning('Warning', 'No image selected');
    }
  }

// ! uploadImageToCloudinary
  Future<void> uploadImageToCloudinary() async {
    try {
      File imageFile = File(selectedImagePath!.value);
      String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/${AppUrl.cloudName}/image/upload";

      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = AppUrl.uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        imageUrl.value = jsonResponse['secure_url'];
        Utils.showSuccess(
          'Success',
          'Image uploaded successfully!',
          icon: const Icon(Ionicons.fast_food_outline),
        );
      } else {
        Utils.showWarning('Warning', 'Failed to upload image');
      }
    } catch (e) {
      Utils.showError('Error', 'An error occurred: $e');
    }
  }

  // ! fetchUserData
  Future<void> fetchUserData() async {
    final String? accessToken = box1.read("token");
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/user');
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        user = UserInformationModel.fromJson(data);

        imageUrl.value = user!.profile;
        // print('user all data:$user');
        // print(response.statusCode);
        // print('api calling:${imageUrl.value}');
      } else {
        errorModelFromJson(response.body);
        //  var apiError = errorModelFromJson(response.body);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refetchUserData() {
    fetchUserData();
  }

  // ! user update
  Future<void> updateUser(var data) async {
    final String? accessToken = box1.read("token");
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      Uri url = Uri.parse('${AppUrl.baseUrl}/api/user');
      final response = await http.put(
        url,
        headers: headers,
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Utils.showSuccess(
          'Success',
          'User updated successfully!',
          icon: const Icon(Icons.update_rounded),
        );
      } else {
        isLoading.value = false;
        Utils.showError('Error', 'Failed to update user!');
      }
    } catch (error) {
      isLoading.value = false;
      Utils.showError('Error', '$error');
    } finally {
      isLoading.value = false;
    }
  }
}
