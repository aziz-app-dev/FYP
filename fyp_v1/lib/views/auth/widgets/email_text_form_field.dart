import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/res/colors/app_color.dart';

/// Mirrors the user app's EmailTextFormField.
class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    super.key,
    this.onEditingComplete,
    this.keyboardType,
    this.initialValue,
    required this.controller,
    this.hintText,
    this.prefixIcon,
  });

  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final String? initialValue;
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 20.spMin,
      textInputAction: TextInputAction.next,
      controller: controller,
      cursorColor: kDark,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      validator: (v) =>
          (v == null || v.isEmpty) ? 'Email address is required.' : null,
      style: TextStyle(
        color: kDark,
        fontSize: 14.spMin,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
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
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderSide: BorderSide(color: c, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(9.r)),
      );
}
