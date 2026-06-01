import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/login/login_response_model.dart';

/// Handles the PUT /api/user call for profile edits + keeps the
/// cached LoginResponseModel in GetStorage fresh so the header on
/// the profile screen updates immediately.
class ProfileEditController extends GetxController {
  final box = GetStorage();

  final RxBool _saving = false.obs;
  bool get isSaving => _saving.value;

  Future<bool> save({
    required String username,
    required String phone,
    required String profileUrl,
  }) async {
    _saving.value = true;
    try {
      final token = box.read('token');
      final userId = box.read('userId');
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/api/user'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': username,
          'phone': phone,
          'profile': profileUrl,
        }),
      );

      if (response.statusCode != 200) {
        final err = errorModelFromJson(response.body);
        Utils.showError('Update failed', err.message);
        return false;
      }

      // Refresh the locally-cached user so the header reflects the new
      // values without needing a full re-login.
      if (userId != null) {
        final raw = box.read(userId.toString());
        if (raw != null) {
          final cached = loginResponseModelFromJson(raw);
          final merged = LoginResponseModel(
            id: cached.id,
            username: username,
            email: cached.email,
            verification: cached.verification,
            fmc: cached.fmc,
            phone: phone,
            phoneVerification: cached.phoneVerification,
            userType: cached.userType,
            profile: profileUrl,
            userToken: cached.userToken,
          );
          box.write(userId.toString(), loginResponseModelToJson(merged));
        }
      }

      Utils.showSuccess('Profile updated', 'Your info has been saved.');
      return true;
    } catch (e) {
      Utils.showError('Error', e.toString());
      return false;
    } finally {
      _saving.value = false;
    }
  }
}
