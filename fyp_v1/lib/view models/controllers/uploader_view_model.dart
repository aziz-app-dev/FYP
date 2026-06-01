// ignore_for_file: unused_local_variable, prefer_final_fields

// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../common/res/colors/app_color.dart';

// class UploaderController extends GetxController {
//   var imagePath1 = Rxn<File>();
//   var imagePath2 = Rxn<File>();
//   var imagePath3 = Rxn<File>();
//   var imagePath4 = Rxn<File>();
//   var logo = Rxn<File>();
//   var cover = Rxn<File>();

//   final RxList<String> _image = <String>[].obs;

//   List<String> get image => _image;

//   set setImages(String newVal) {
//     _image.add(newVal);
//   }

//   RxString _imageOneUrl = ''.obs;
//   RxString _imageTwoUrl = ''.obs;
//   RxString _imageThreeUrl = ''.obs;
//   RxString _imageFourUrl = ''.obs;
//   RxString _logoUrl = ''.obs;
//   RxString _coverUrl = ''.obs;

//   String get imageOneUrl => _imageOneUrl.value;
//   String get imageTwoUrl => _imageTwoUrl.value;
//   String get imageThreeUrl => _imageThreeUrl.value;
//   String get imageFourUrl => _imageFourUrl.value;
//   String get logoUrl => _logoUrl.value;
//   String get coverUrl => _coverUrl.value;

//   set setLogoUrl(String newValue) {
//     _logoUrl.value = newValue;
//   }

//   set setCoverUrl(String newValue) {
//     _coverUrl.value = newValue;
//   }

//   set setImageOneUrl(String newValue) {
//     _imageOneUrl.value = newValue;
//   }

//   set setImageTwoUrl(String newValue) {
//     _imageTwoUrl.value = newValue;
//   }

//   set setImageThreeUrl(String newValue) {
//     _imageThreeUrl.value = newValue;
//   }

//   set setImageFourUrl(String newValue) {
//     _imageFourUrl.value = newValue;
//   }

//   var isLoading = false.obs;
//   var error = ''.obs;
//   final ImagePicker _picker = ImagePicker();

//   // ! pickImage
//   // Future<void> pickImage(String type) async {
//   //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   //   if (pickedFile != null) {
//   //     File selectedImage = File(pickedFile.path);

//   //     if (type == 'one') {
//   //       imagePath1.value = selectedImage;
//   //     } else if (type == 'two') {
//   //       imagePath2.value = selectedImage;
//   //     } else if (type == 'three') {
//   //       imagePath3.value = selectedImage;
//   //     } else if (type == 'four') {
//   //       imagePath4.value = selectedImage;
//   //     } else if (type == 'logo') {
//   //       logo.value = selectedImage;
//   //     } else if (type == 'cover') {
//   //       cover.value = selectedImage;
//   //     }

//   //     // After picking the image, upload it to Firebase
//   //     await uploadImageToFirebase(type);
//   //   } else {
//   //     Get.snackbar('Warning', 'No image selected',
//   //         colorText: kLightWhite,
//   //         backgroundColor: kRed,
//   //         icon: const Icon(Ionicons.warning));
//   //   }
//   // }

//   Future<void> uploadImageToFirebase(String type) async {
//     File? imageFile;
//     String filename;

//     if (type == 'one') {
//       imageFile = imagePath1.value;
//     } else if (type == 'two') {
//       imageFile = imagePath2.value;
//     } else if (type == 'three') {
//       imageFile = imagePath3.value;
//     } else if (type == 'four') {
//       imageFile = imagePath4.value;
//     } else if (type == 'logo') {
//       imageFile = logo.value;
//     } else if (type == 'cover') {
//       imageFile = cover.value;
//     }

//     if (imageFile != null) {
//       filename =
//           'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
//       try {
//         TaskSnapshot snapshot = await FirebaseStorage.instance
//             .ref()
//             .child(filename)
//             .putFile(imageFile);
//         String downloadUrl = await snapshot.ref.getDownloadURL();

//         // Update the correct URL based on the type
//         if (type == 'one') {
//           setImageOneUrl = downloadUrl;
//         } else if (type == 'two') {
//           setImageTwoUrl = downloadUrl;
//         } else if (type == 'three') {
//           setImageThreeUrl = downloadUrl;
//         } else if (type == 'four') {
//           setImageFourUrl = downloadUrl;
//         } else if (type == 'logo') {
//           setLogoUrl = downloadUrl;
//         } else if (type == 'cover') {
//           setCoverUrl = downloadUrl;
//         }
//       } catch (e) {
//         print(e);
//       }
//     }
//   }
//   Future<void> pickImage(String type) async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       if (type == 'one') {
//         imagePath1.value = File(pickedFile.path);
//         // print(imagePath1.value);
//         return;
//       } else if (type == 'two') {
//         imagePath2.value = File(pickedFile.path);
//         // print(imagePath1.value);
//         return;
//       } else if (type == 'three') {
//         imagePath3.value = File(pickedFile.path);
//         // print(imagePath1.value);
//         return;
//       } else if (type == 'four') {
//         imagePath4.value = File(pickedFile.path);
//         // print(imagePath1.value);
//         return;
//       } else if (type == 'logo') {
//         logo.value = File(pickedFile.path);
//         // print(imagePath1.value);
//         return;
//       } else if (type == 'cover') {
//         cover.value = File(pickedFile.path);
//         // print(imagePath1.value);
//         return;
//       }
//     } else {
//       Get.snackbar('Warring', 'No image selected',
//           colorText: kLightWhite,
//           backgroundColor: kRed,
//           icon: const Icon(Ionicons.warning));
//     }
//   }

//   // Future<void> uploadImageToFirebase(String type) async {
//   //   if (type == 'one') {
//   //     try {
//   //       String filename =
//   //           'images/${DateTime.now().millisecondsSinceEpoch}_${imagePath1.value!.path.split('/').last}';

//   //       // TaskSnapshot
//   //       TaskSnapshot snapshot = await FirebaseStorage.instance
//   //           .ref()
//   //           .child(filename)
//   //           .putFile(imagePath1.value!);
//   //       setImageOneUrl = await snapshot.ref.getDownloadURL();
//   //     } catch (e) {
//   //       print(e);
//   //     }
//   //   } else if (type == 'two') {
//   //     try {
//   //       String filename =
//   //           'images/${DateTime.now().millisecondsSinceEpoch}_${imagePath2.value!.path.split('/').last}';

//   //       // TaskSnapshot
//   //       TaskSnapshot snapshot = await FirebaseStorage.instance
//   //           .ref()
//   //           .child(filename)
//   //           .putFile(imagePath2.value!);
//   //       setImageOneUrl = await snapshot.ref.getDownloadURL();
//   //     } catch (e) {
//   //       print(e);
//   //     }
//   //   } else if (type == 'three') {
//   //     try {
//   //       String filename =
//   //           'images/${DateTime.now().millisecondsSinceEpoch}_${imagePath3.value!.path.split('/').last}';

//   //       // TaskSnapshot
//   //       TaskSnapshot snapshot = await FirebaseStorage.instance
//   //           .ref()
//   //           .child(filename)
//   //           .putFile(imagePath3.value!);
//   //       setImageOneUrl = await snapshot.ref.getDownloadURL();
//   //     } catch (e) {
//   //       print(e);
//   //     }
//   //   } else if (type == 'four') {
//   //     try {
//   //       String filename =
//   //           'images/${DateTime.now().millisecondsSinceEpoch}_${imagePath4.value!.path.split('/').last}';

//   //       // TaskSnapshot
//   //       TaskSnapshot snapshot = await FirebaseStorage.instance
//   //           .ref()
//   //           .child(filename)
//   //           .putFile(imagePath4.value!);
//   //       setImageOneUrl = await snapshot.ref.getDownloadURL();
//   //     } catch (e) {
//   //       print(e);
//   //     }
//   //   } else if (type == 'logo') {
//   //     try {
//   //       String filename =
//   //           'images/${DateTime.now().millisecondsSinceEpoch}_${logo.value!.path.split('/').last}';

//   //       // TaskSnapshot
//   //       TaskSnapshot snapshot = await FirebaseStorage.instance
//   //           .ref()
//   //           .child(filename)
//   //           .putFile(logo.value!);
//   //       setImageOneUrl = await snapshot.ref.getDownloadURL();
//   //     } catch (e) {
//   //       print(e);
//   //     }
//   //   } else if (type == 'cover') {
//   //     try {
//   //       String filename =
//   //           'images/${DateTime.now().millisecondsSinceEpoch}_${cover.value!.path.split('/').last}';

//   //       // TaskSnapshot
//   //       TaskSnapshot snapshot = await FirebaseStorage.instance
//   //           .ref()
//   //           .child(filename)
//   //           .putFile(cover.value!);
//   //       setImageOneUrl = await snapshot.ref.getDownloadURL();
//   //     } catch (e) {
//   //       print(e);
//   //     }
//   //   }
//   // }
// }

// ! ==============

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/res/colors/app_color.dart';

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

  // RxString imageOneUrl = ''.obs;
  // RxString imageTwoUrl = ''.obs;
  // RxString imageThreeUrl = ''.obs;
  // RxString imageFourUrl = ''.obs;
  // RxString logoUrl = ''.obs;
  // RxString coverUrl = ''.obs;
  RxString _imageOneUrl = ''.obs;
  RxString _imageTwoUrl = ''.obs;
  RxString _imageThreeUrl = ''.obs;
  RxString _imageFourUrl = ''.obs;
  RxString _logoUrl = ''.obs;
  RxString _coverUrl = ''.obs;

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
          Get.snackbar('Error', 'Invalid image type',
              colorText: kLightWhite,
              backgroundColor: kRed,
              icon: const Icon(Ionicons.warning));
      }

      // Automatically upload image after selection
      await uploadImageToCloudinary(type);
    } else {
      Get.snackbar('Warning', 'No image selected',
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Ionicons.warning));
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

        print(response);
        print(response.statusCode);

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);

          print(jsonResponse);

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

          Get.snackbar('Success', 'Image uploaded successfully',
              colorText: kLightWhite,
              backgroundColor: Colors.green,
              icon: const Icon(Ionicons.checkmark_circle));
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
