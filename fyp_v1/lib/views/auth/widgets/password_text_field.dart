import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../view models/controllers/password_view_model.dart';

/// Mirrors the user app's PasswordFormField — obscure toggle, primary border.
class PasswordFormField extends StatelessWidget {
  const PasswordFormField({
    super.key,
    this.onEditingComplete,
    required this.controller,
    this.hintText,
    this.prefixIcon,
  });

  final VoidCallback? onEditingComplete;
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final passwordController = Get.put(PasswordController());
    return Obx(
      () => TextFormField(
        cursorHeight: 20.spMin,
        textInputAction: TextInputAction.next,
        controller: controller,
        cursorColor: kDark,
        onEditingComplete: onEditingComplete,
        keyboardType: TextInputType.visiblePassword,
        obscureText: passwordController.password,
        validator: (v) =>
            (v == null || v.isEmpty) ? 'Password is required.' : null,
        style: TextStyle(
          fontSize: 14.spMin,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: GestureDetector(
            onTap: () =>
                passwordController.setPassword = !passwordController.password,
            child: Icon(passwordController.password
                ? Icons.visibility_off
                : Icons.visibility_outlined),
          ),
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          hintStyle: TextStyle(
            fontSize: 14.spMin,
            fontWeight: FontWeight.normal,
          ),
          errorBorder: _border(kRed),
          focusedErrorBorder: _border(kRed),
          focusedBorder: _border(kPrimary),
          disabledBorder: _border(kGray),
          enabledBorder: _border(kPrimary),
          border: _border(kPrimary),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderSide: BorderSide(color: c, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(9.r)),
      );
}
