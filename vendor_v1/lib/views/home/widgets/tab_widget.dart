import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width / 4,
      height: 20.h,
      child: Center(
        child: Text(text),
      ), // Center
    ); // Container
  }
}
