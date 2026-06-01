import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../res/app_url/app_url.dart';
import '../../../utils/utils.dart';

class UploaderController extends GetxController {
  var imagePath1 = Rxn<File>();
  var imagePath2 = Rxn<File>();
  var imagePath3 = Rxn<File>();
  var imagePath4 = Rxn<File>();
  var logo = Rxn<File>();
  var cover = Rxn<File>();
  final RxList<String> _image = <String>[].obs;

  List<String> get image => _image;

  set setImages(String newVal) {
    _image.add(newVal);
  }

  final RxString _imageOneUrl = ''.obs;
  final RxString _imageTwoUrl = ''.obs;
  final RxString _imageThreeUrl = ''.obs;
  final RxString _imageFourUrl = ''.obs;
  final RxString _logoUrl = ''.obs;
  final RxString _coverUrl = ''.obs;

  String get imageOneUrl => _imageOneUrl.value;
  String get imageTwoUrl => _imageTwoUrl.value;
  String get imageThreeUrl => _imageThreeUrl.value;
  String get imageFourUrl => _imageFourUrl.value;
  String get logoUrl => _logoUrl.value;
  String get coverUrl => _coverUrl.value;

  set setLogoUrl(String newValue) {
    _logoUrl.value = newValue;
  }

  set setCoverUrl(String newValue) {
    _coverUrl.value = newValue;
  }

  set setImageOneUrl(String newValue) {
    _imageOneUrl.value = newValue;
    image.add(newValue);
  }

  set setImageTwoUrl(String newValue) {
    _imageTwoUrl.value = newValue;
    image.add(newValue);
  }

  set setImageThreeUrl(String newValue) {
    _imageThreeUrl.value = newValue;
    image.add(newValue);
  }

  set setImageFourUrl(String newValue) {
    _imageFourUrl.value = newValue;
    image.add(newValue);
  }

  var isLoading = false.obs;

  var error = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      switch (type) {
        case 'one':
          imagePath1.value = imageFile;
          break;
        case 'two':
          imagePath2.value = imageFile;
          break;
        case 'three':
          imagePath3.value = imageFile;
          break;
        case 'four':
          imagePath4.value = imageFile;
          break;
        case 'logo':
          logo.value = imageFile;
          break;
        case 'cover':
          cover.value = imageFile;
          break;
        default:
          Utils.showError('Error', 'Invalid image type');
      }

      // Automatically upload image after selection
      await uploadImageToCloudinary(type);
    } else {
      Utils.showWarning('Warning', 'No image selected');
    }
  }

  Future<void> uploadImageToCloudinary(String type) async {
    try {
      String? filePath;
      switch (type) {
        case 'one':
          filePath = imagePath1.value?.path;
          break;
        case 'two':
          filePath = imagePath2.value?.path;
          break;
        case 'three':
          filePath = imagePath3.value?.path;
          break;
        case 'four':
          filePath = imagePath4.value?.path;
          break;
        case 'logo':
          filePath = logo.value?.path;
          break;
        case 'cover':
          filePath = cover.value?.path;
          break;
      }

      if (filePath != null) {
        isLoading.value = true;

        const String cloudinaryUrl =
            "https://api.cloudinary.com/v1_1/${AppUrl.cloudName}/image/upload";

        var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
          ..fields['upload_preset'] = AppUrl.uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', filePath));

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);

          String imageUrl = jsonResponse['secure_url'];
          switch (type) {
            case 'one':
              setImageOneUrl = imageUrl;
              break;
            case 'two':
              setImageTwoUrl = imageUrl;
              break;
            case 'three':
              setImageThreeUrl = imageUrl;
              break;
            case 'four':
              setImageFourUrl = imageUrl;
              break;
            case 'logo':
              setLogoUrl = imageUrl;
              break;
            case 'cover':
              setCoverUrl = imageUrl;
              break;
          }

          Utils.showSuccess(
            'Success',
            'Image uploaded successfully',
            icon: const Icon(Ionicons.checkmark_circle),
          );
        } else {
          error.value = 'Failed to upload image to Cloudinary';
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
