import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReuseableText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign textAlign;
  final TextOverflow? overflow;

  const ReuseableText(
      {super.key,
      required this.text,
      this.fontSize = 15,
      this.fontWeight = FontWeight.normal,
      this.textColor = Colors.black,
      this.textAlign = TextAlign.start, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: overflow,
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontSize.spMin, fontWeight: fontWeight, color: textColor),
    );
  }
}
