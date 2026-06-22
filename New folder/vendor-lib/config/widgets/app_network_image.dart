import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A network image widget with built-in error handling.
/// SVG or invalid URLs gracefully show the [errorWidget] fallback.
class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ?? _defaultError();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (_, _, _) => errorWidget ?? _defaultError(),
    );
  }

  Widget _defaultPlaceholder() => SizedBox(
        width: width,
        height: height,
        child: const Center(child: Icon(Icons.fastfood, color: Colors.grey)),
      );

  Widget _defaultError() => SizedBox(
        width: width,
        height: height,
        child: const Center(child: Icon(Icons.fastfood, color: Colors.grey)),
      );
}
