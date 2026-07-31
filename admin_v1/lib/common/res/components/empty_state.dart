import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import 'reuseable_text.dart';

/// Centered placeholder for empty lists.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: kGrayLight),
            const SizedBox(height: 16),
            ReuseableText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: kDark,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            ReuseableText(
              text: message,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: kGray,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
