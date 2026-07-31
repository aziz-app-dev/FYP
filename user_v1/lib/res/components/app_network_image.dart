import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/app_color.dart';

/// App-wide reusable cached network image.
///
/// Handles null/empty URLs, shows a neutral placeholder while loading,
/// and falls back to a branded error widget if the image can't be fetched.
///
/// Use everywhere the app displays remote images to get consistent caching,
/// loading, and error behavior.
class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final IconData fallbackIcon;
  final double? fallbackIconSize;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.fallbackIcon = Icons.image_not_supported_outlined,
    this.fallbackIconSize,
    this.placeholder,
    this.errorWidget,
  });

  bool get _hasValidUrl =>
      imageUrl != null &&
      imageUrl!.trim().isNotEmpty &&
      Uri.tryParse(imageUrl!)?.hasScheme == true;

  @override
  Widget build(BuildContext context) {
    Widget child = _hasValidUrl
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => _buildPlaceholder(),
            errorWidget: (context, url, error) => _buildError(),
          )
        : _buildError();

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? kLightWhite,
      alignment: Alignment.center,
      child: SizedBox(
        width: 22.w,
        height: 22.w,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(kPrimary),
        ),
      ),
    );
  }

  Widget _buildError() {
    if (errorWidget != null) return errorWidget!;
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? kOffWhite,
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        size: fallbackIconSize ?? 32.spMin,
        color: kGray,
      ),
    );
  }
}
