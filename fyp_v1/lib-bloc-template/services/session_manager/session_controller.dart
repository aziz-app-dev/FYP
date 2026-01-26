import 'dart:convert'; // Importing dart:convert for JSON encoding and decoding

import 'package:flutter/material.dart'; // Importing Flutter material library

import '../../model/user/user_model.dart'; // Importing the user model for user data
import '../storage/local_storage.dart'; // Importing local storage for storing user data

class SessionController {
  final LocalStorage sharedPreferenceClass = LocalStorage();

  static final SessionController _session = SessionController._internal();

  static bool? isLogin;

  /// Model representing the user data.
  static UserModel user = UserModel();

  SessionController._internal() {
    isLogin = false;
  }

  factory SessionController() {
    return _session;
  }
  Future<void> saveUserInPreference(dynamic user) async {
    sharedPreferenceClass.setValue('token', jsonEncode(user));
    // Storing value to check login
    sharedPreferenceClass.setValue('isLogin', 'true');
  }

  Future<void> getUserFromPreference() async {
    try {
      String userData = await sharedPreferenceClass.readValue('token');
      var isLogin = await sharedPreferenceClass.readValue('isLogin');

      if (userData.isNotEmpty) {
        SessionController.user = UserModel.fromJson(jsonDecode(userData));
      }
      SessionController.isLogin = isLogin == 'true' ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
