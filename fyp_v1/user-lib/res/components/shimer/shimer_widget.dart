import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimerWidget extends StatelessWidget {
  final double shimerWidth;
  final double shimerHeight;
  final double shimerRadius;
  const ShimerWidget(
      {super.key,
      required this.shimerWidth,
      required this.shimerHeight,
      required this.shimerRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shimerWidth,
      height: shimerHeight,
      padding: const EdgeInsets.only(right: 12, top: 8.0),
      child: _buildShimmerLine(
          height: shimerHeight - 20,
          width: shimerWidth - 15,
          radius: shimerRadius - 15),
    );
  }
}

Widget _buildShimmerLine(
    {required double height, required double width, required double radius}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
