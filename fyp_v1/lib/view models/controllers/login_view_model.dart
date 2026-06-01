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

/// Vendor login controller. Mirrors the user app's `loginFunction`
/// pattern: POST /login, persist the full user payload + token into
/// GetStorage (keyed by user id), then navigate.
///
/// Adds two things the user app's version lacks:
///   - a 10s timeout (so the "Signing in…" button doesn't hang forever
///     when the server is offline)
///   - a `userType` guard so only Vendor / Admin accounts get in.
class LoginController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool v) => _isLoading.value = v;

  Future<void> login(String email, String password) async {
    setLoading = true;
    try {
      final data = jsonEncode({'email': email, 'password': password});
      final url = Uri.parse('${AppUrl.baseUrl}/login');
      final headers = {'Content-Type': 'application/json'};

      final response = await http
          .post(url, headers: headers, body: data)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final user = loginResponseModelFromJson(response.body);

        // Guard: reject non-vendor accounts BEFORE persisting anything.
        if (user.userType != 'Vendor' && user.userType != 'Admin') {
          Utils.showError(
              'Not a vendor', 'Use the customer app to log in as a client.');
          return;
        }

        // Mirror the user app's storage layout:
        //   box[userId]      -> full LoginResponseModel as JSON
        //   box['token']     -> JWT
        //   box['userId']    -> user id
        //   box['userType']  -> "Vendor" / "Admin" (extra, for splash routing)
        //   box['verification'] -> email verification bool
        box.write(user.id, loginResponseModelToJson(user));
        box.write('token', user.userToken);
        box.write('userId', user.id);
        box.write('userType', user.userType);
        box.write('verification', user.verification);

        if (kDebugMode) {
          debugPrint('user login ok');
          debugPrint('token: ${user.userToken}');
        }

        Utils.showSuccess('Welcome back', user.username);
        Get.offAllNamed(RouteName.vendorHome);
      } else {
        // Server returned a non-200 (e.g. bad credentials)
        final err = errorModelFromJson(response.body);
        Utils.showError('Failed to login', err.message);
      }
    } on TimeoutException {
      Utils.showError('Server unreachable',
          'The request took too long. Check your connection or try again.');
    } on SocketException {
      Utils.showError('No internet',
          'Cannot reach the server. Please check your connection.');
    } on http.ClientException {
      Utils.showError('Network error',
          'Cannot reach the server. Is the backend running?');
    } on FormatException {
      Utils.showError(
          'Bad response', 'Server sent an unexpected response.');
    } catch (e) {
      if (kDebugMode) debugPrint('login error: $e');
      Utils.showError('Error', e.toString());
    } finally {
      // Always clear the spinner — even on timeout/network errors.
      setLoading = false;
    }
  }

  /// Clear cached auth state and send user back to login.
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
