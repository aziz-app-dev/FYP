import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReuseableText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const ReuseableText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.fontWeight,
      this.textColor = Colors.black,
      this.textAlign = TextAlign.start,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
        overflow: overflow,
        text,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
            color: textColor, fontSize: fontSize, fontWeight: fontWeight)
        //  TextStyle(
        //     fontSize: fontSize.spMin, fontWeight: fontWeight, color: textColor),
        );
  }
}
