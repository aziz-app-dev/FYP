import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/colors/app_color.dart';

class AddressFormField extends StatelessWidget {
  const AddressFormField({
    super.key,
    this.onEditingComplete,
    this.keyboardType,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.validatorText,
    this.label,
  });

  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? hintText;
  final String? validatorText;
  final Widget? label;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 20.spMin,
      textInputAction: TextInputAction.next,
      controller: controller,
      cursorColor: kDark,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return validatorText;
        } else {
          return null;
        }
      },
      style:
          GoogleFonts.gulzar(fontSize: 15.spMin, fontWeight: FontWeight.normal),
      // style: TextStyle(
      //   color: kDark,
      //   fontSize: 14.spMin,
      //   fontWeight: FontWeight.normal,
      // ),
      decoration: InputDecoration(
        label: label,
        hintText: hintText,
        prefixIcon: prefixIcon ??
            const Icon(
              Icons.location_pin,
            ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
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
