import 'package:flutter/material.dart';

import '../colors/app_color.dart';

/// Small colored pill used for order / verification statuses.
class StatusChip extends StatelessWidget {
  final String label;

  const StatusChip({super.key, required this.label});

  static Color colorFor(String status) {
    switch (status) {
      case 'Pending':
        return kSecondary;
      case 'Preparing':
        return kTertiary;
      case 'Ready':
        return kPrimary;
      case 'Out For Delivery':
      case 'Delivering':
        return const Color(0xff7b61ff);
      case 'Delivered':
      case 'Verified':
      case 'Completed':
        return const Color(0xff2e9e5b);
      case 'Cancelled':
      case 'Rejected':
      case 'Failed':
        return kRed;
      default:
        return kGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
