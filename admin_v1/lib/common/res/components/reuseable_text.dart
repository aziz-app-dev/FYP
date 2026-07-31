import 'package:flutter/material.dart';

/// Reusable text with sane defaults. Uses the platform default font
/// to avoid Google Fonts runtime-fetch crashes when the device is offline.
class ReuseableText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ReuseableText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.start,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
