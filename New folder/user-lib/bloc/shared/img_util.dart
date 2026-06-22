// package:testings/testings/bloc/bloc/shared/img_util.dart

import 'package:image_picker/image_picker.dart';
// Add this import for platform checking
import 'dart:io' show Platform;

class ImgUtil {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> cameraImg() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery, // <-- CHANGED THIS
      );
      return file;
    } else {
      // Use camera on mobile platforms
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      return file;
    }
  }

  Future<XFile?> galleryImg() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return file;
  }
}
