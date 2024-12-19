import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/colors/app_color.dart';
import '../../../view_models/controller/password/password_view_model.dart';

class PasswordFormField extends StatelessWidget {
  const PasswordFormField(
      {super.key,
      this.onEditingComplete,
      this.keyboardType,
      this.initialValue,
      required this.controller,
      this.hintText,
      this.prefixIcon});

  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final String? initialValue;
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
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password is required.';
          } else {
            return null;
          }
        },
        style: TextStyle(
          fontSize: 14.spMin,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: GestureDetector(
              onTap: () {
                passwordController.setPassword = !passwordController.password;
              },
              child: Icon(passwordController.password
                  ? Icons.visibility_off
                  : Icons.visibility_outlined)),
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          hintStyle: TextStyle(
            fontSize: 14.spMin,
            fontWeight: FontWeight.normal,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kRed, width: .5),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kRed, width: .5),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimary, width: .5),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kGray, width: .5),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimary, width: .5),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimary, width: .5),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
        ),
      ),
    );
  }
}
