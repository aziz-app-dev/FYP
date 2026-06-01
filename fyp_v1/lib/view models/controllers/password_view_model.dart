import 'package:get/get.dart';

/// Toggles password visibility on PasswordFormField.
class PasswordController extends GetxController {
  final RxBool _obscure = true.obs;
  bool get password => _obscure.value;
  set setPassword(bool v) => _obscure.value = v;
}
