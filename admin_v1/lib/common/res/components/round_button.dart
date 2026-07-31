import 'package:flutter/material.dart';

import '../colors/app_color.dart';

/// Primary action button with a built-in loading state.
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool loading;
  final Color color;
  final double height;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.loading = false,
    this.color = kPrimary,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: loading ? color.withValues(alpha: 0.6) : color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: kLightWhite,
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  color: kLightWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
