import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/session/session_manger.dart';
import '../config.dart';

enum PriceFractionPosition { top, bottom }

enum PriceAnimation {
  /// Fade + slide up from below
  fadeSlideUp,

  /// Fade + slide down from above
  fadeSlideDown,

  /// Simple crossfade
  fade,

  /// Scale up from center
  scale,

  /// Scale + fade combined
  scaleFade,

  /// Slide in from right
  slideRight,

  /// Flip vertically (3D-like rotation on X axis)
  flipY,
}

/// Formats a price value with the currency symbol from backend settings.
///
/// Examples:
///   formatPrice(9.99)          => "$9.99"
///   formatPrice(9.99, prefix: '+') => "+$9.99"
///   formatPrice(0)             => "$0.00"
String formatPrice(double price, {String prefix = ''}) {
  final symbol = SessionManager().currencySymbol;
  return '$prefix$symbol${price.toStringAsFixed(2)}';
}

/// A reusable price text widget that displays a formatted price
/// using the currency symbol from backend settings.
class PriceText extends StatelessWidget {
  final double price;
  final String prefix;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final double symbolSizeRatio;
  final double fractionSizeRatio;
  final PriceFractionPosition fractionPosition;
  final double fractionVerticalOffsetFactor;
  final double? symbolGap;
  final PriceAnimation? animation;
  final Duration animationDuration;

  const PriceText({
    super.key,
    required this.price,
    this.prefix = '',
    this.style,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.symbolSizeRatio = AppSizes.priceSymbolSizeRatio,
    this.fractionSizeRatio = AppSizes.priceFractionSizeRatio,
    this.fractionPosition = PriceFractionPosition.top,
    this.fractionVerticalOffsetFactor =
        AppSizes.priceFractionVerticalOffsetFactor,
    this.symbolGap,
    this.animation,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final symbol = SessionManager().currencySymbol;
    final amountParts = price.toStringAsFixed(2).split('.');
    final wholePart = amountParts.first;
    final fractionPart = amountParts.length > 1 ? amountParts[1] : '00';
    final effectiveStyle =
        style ??
        TextStyle(
          color: color ?? colors.primary,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontSize: fontSize ?? 14.spMin,
        );
    final symbolStyle = effectiveStyle.copyWith(
      fontSize: (effectiveStyle.fontSize ?? 14.spMin) * symbolSizeRatio,
    );
    final fractionStyle = effectiveStyle.copyWith(
      fontSize: (effectiveStyle.fontSize ?? 14.spMin) * fractionSizeRatio,
    );
    final fractionYOffset =
        (effectiveStyle.fontSize ?? 14.spMin) * fractionVerticalOffsetFactor;

    final richText = RichText(
      key: animation != null ? ValueKey(price) : null,
      text: TextSpan(
        style: effectiveStyle,
        children: [
          if (prefix.isNotEmpty) TextSpan(text: prefix),
          TextSpan(text: symbol, style: symbolStyle),
          WidgetSpan(child: SizedBox(width: symbolGap ?? 2.spMin)),
          TextSpan(text: '$wholePart.'),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Transform.translate(
              offset: Offset(
                0,
                fractionPosition == PriceFractionPosition.top
                    ? -fractionYOffset
                    : fractionYOffset,
              ),
              child: Text(fractionPart, style: fractionStyle),
            ),
          ),
        ],
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );

    if (animation == null) return richText;

    return AnimatedSwitcher(
      duration: animationDuration,
      transitionBuilder: _buildTransition,
      child: richText,
    );
  }

  Widget _buildTransition(Widget child, Animation<double> anim) {
    return switch (animation!) {
      PriceAnimation.fadeSlideUp => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      PriceAnimation.fadeSlideDown => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      PriceAnimation.fade => FadeTransition(
        opacity: anim,
        child: child,
      ),
      PriceAnimation.scale => ScaleTransition(
        scale: anim,
        child: child,
      ),
      PriceAnimation.scaleFade => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      ),
      PriceAnimation.slideRight => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.5, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: FadeTransition(opacity: anim, child: child),
      ),
      PriceAnimation.flipY => AnimatedBuilder(
        animation: anim,
        child: child,
        builder: (context, child) {
          final angle = (1 - anim.value) * math.pi / 2;
          return Opacity(
            opacity: anim.value,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(angle),
              child: child,
            ),
          );
        },
      ),
    };
  }
}
