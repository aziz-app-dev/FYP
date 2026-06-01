import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/res_imports.dart';

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
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email address is required.';
        } else {
          return null;
        }
      },
      style: TextStyle(
        color: kDark,
        fontSize: 14.spMin,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
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
    );
  }
}
