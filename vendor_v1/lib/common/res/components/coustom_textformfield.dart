// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../colors/app_color.dart';

// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final VoidCallback? onEditingComplete;
//   final bool? obscureText;
//   final Widget? suffixIcon;
//   final Widget prefixIcon;
//   final String? hintText;
//   final Color borderColor;
//   final double borderRadius;
//   final TextStyle? textStyle;
//   final TextStyle? hintStyle;
//   final int maxLines;

//   const CustomTextFormField({
//     super.key,
//     this.controller,
//     this.keyboardType,
//     this.onEditingComplete,
//     this.obscureText,
//     this.suffixIcon,
//     required this.prefixIcon,
//     this.hintText,
//     this.borderColor = kPrimary,
//     this.borderRadius = 9.0,
//     this.textStyle,
//     this.hintStyle,
//     this.maxLines = 1,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       cursorColor: kGray,
//       onEditingComplete: onEditingComplete,
//       obscureText: obscureText ?? false,
//       cursorHeight: 20.spMin,
//       style: textStyle ?? appStyle(14.spMin, kDark, FontWeight.normal),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter some text';
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         isDense: true,
//         contentPadding: EdgeInsets.all(12.h),
//         // contentPadding: maxLines != 1 ? EdgeInsets.zero : EdgeInsets.all(12.r),
//         hintText: hintText,
//         hintStyle: hintStyle ?? appStyle(14.spMin, kGray, FontWeight.normal),
//         suffixIcon: suffixIcon,
//         prefix: prefixIcon,
//         errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: kRed, width: 0.5.w),
//             borderRadius: BorderRadius.circular(12.r)),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: kPrimary, width: 0.5.w),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: kRed, width: 0.5.w),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: kGray, width: 0.5.w),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: kPrimary, width: 0.5.w),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: kPrimary, width: 0.5.w),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }
// }

// TextStyle appStyle(double fontSize, Color color, FontWeight fontWeight) {
//   return TextStyle(
//     fontSize: fontSize,
//     color: color,
//     fontWeight: fontWeight,
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  int? maxLine;
  CustomTextFormField({
    super.key,
    this.onEditingComplete,
    this.keyboardType,
    this.initialValue,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 20.spMin,
      textInputAction: TextInputAction.next,
      controller: controller,
      cursorColor: kDark,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLine!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Some Text!';
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
        contentPadding: maxLine != 1
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        hintStyle: TextStyle(
            fontSize: 14.spMin, fontWeight: FontWeight.w400, color: kGray),
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
