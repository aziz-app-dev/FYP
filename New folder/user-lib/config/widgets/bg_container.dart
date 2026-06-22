import 'dart:math';
import 'package:flutter/material.dart';
import '../assets/app_images.dart';
import '../theme/theme_colors.dart';

class BgContainer extends StatelessWidget {
  final Widget child;

  /// Desired spacing between icons in logical pixels.
  /// Columns and rows are computed from this so density scales with screen size.
  final double iconSpacing;

  /// Minimum icon size in logical pixels.
  final double minIconSize;

  /// Maximum icon size in logical pixels.
  final double maxIconSize;

  /// Opacity of the food icon images (0.0 - 1.0).
  final double iconOpacity;

  /// Background color. If null, uses `colors.primaryDark`.
  final Color? backgroundColor;

  /// Random seed for deterministic icon placement. Change to get a different layout.
  final int seed;

  const BgContainer({
    super.key,
    required this.child,
    this.iconSpacing = 120.0,
    this.minIconSize = 28.0,
    this.maxIconSize = 60.0,
    this.iconOpacity = 0.15,
    this.backgroundColor,
    this.seed = 90,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(color: backgroundColor ?? colors.primaryDark),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rng = Random(seed);
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final columns = max(1, (width / iconSpacing).round());
          final cellW = width / columns;
          final rows = max(1, (height / cellW).ceil());
          final cellH = height / rows;
          final sizeRange = maxIconSize - minIconSize;
          final images = AppImages.foodIconImages;

          final icons = <Widget>[];
          for (int row = 0; row < rows; row++) {
            for (int col = 0; col < columns; col++) {
              final imgPath = images[rng.nextInt(images.length)];
              final iconSize = minIconSize + rng.nextDouble() * sizeRange;
              final rotation = rng.nextDouble() * pi * 2;
              final x = (col + 0.15 + rng.nextDouble() * 0.7) * cellW -
                  iconSize / 2;
              final y = (row + 0.15 + rng.nextDouble() * 0.7) * cellH -
                  iconSize / 2;

              icons.add(
                Positioned(
                  left: x,
                  top: y,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Opacity(
                      opacity: iconOpacity,
                      child: Image.asset(
                        imgPath,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            }
          }

          return Stack(
            children: [
              ...icons,
              child,
            ],
          );
        },
      ),
    );
  }
}
