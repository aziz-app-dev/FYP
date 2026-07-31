import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../common/res/app_url/app_url.dart';
import '../../common/res/routes/routes_name.dart';
import '../../common/utils/utils.dart';
import '../../models/error/error_model.dart';
import '../../models/login/login_response_model.dart';

/// Admin login controller. Same POST /login + GetStorage layout as the
/// vendor/customer apps, but only `userType == 'Admin'` gets in.
class LoginController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool v) => _isLoading.value = v;

  Future<void> login(String email, String password) async {
    setLoading = true;
    try {
      final data = jsonEncode({'email': email, 'password': password});
      final url = Uri.parse(AppUrl.loginApi);
      final headers = {'Content-Type': 'application/json'};

      final response = await http
          .post(url, headers: headers, body: data)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final user = loginResponseModelFromJson(response.body);

        // Guard: this app is for the platform super admin only.
        if (user.userType != 'Admin') {
          Utils.showError('Not an admin',
              'This app is for platform administrators only.');
          return;
        }

        // Mirror the other apps' storage layout:
        //   box[userId]      -> full LoginResponseModel as JSON
        //   box['token']     -> JWT
        //   box['userId']    -> user id
        //   box['userType']  -> "Admin"
        //   box['verification'] -> email verification bool
        box.write(user.id, loginResponseModelToJson(user));
        box.write('token', user.userToken);
        box.write('userId', user.id);
        box.write('userType', user.userType);
        box.write('verification', user.verification);

        if (kDebugMode) debugPrint('admin login ok');

        Utils.showSuccess('Welcome back', user.username);
        Get.offAllNamed(RouteName.adminHome);
      } else {
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to login', err.message);
      }
    } on TimeoutException {
      Utils.showError('Server unreachable',
          'The request took too long. Check your connection or try again.');
    } on SocketException {
      Utils.showError(
          'No internet', 'Cannot reach the server. Please check your connection.');
    } on http.ClientException {
      Utils.showError(
          'Network error', 'Cannot reach the server. Is the backend running?');
    } on FormatException {
      Utils.showError('Bad response', 'Server sent an unexpected response.');
    } catch (e) {
      if (kDebugMode) debugPrint('login error: $e');
      Utils.showError('Error', e.toString());
    } finally {
      setLoading = false;
    }
  }

  /// Clear cached auth state and send the admin back to login.
  void logout() {
    box.erase();
    Get.offAllNamed(RouteName.LoginScreen);
  }

  /// Read the cached login response from storage.
  LoginResponseModel? getUserInfo() {
    final userId = box.read('userId');
    if (userId == null) return null;
    final raw = box.read(userId.toString());
    if (raw == null) return null;
    return loginResponseModelFromJson(raw);
  }
}
