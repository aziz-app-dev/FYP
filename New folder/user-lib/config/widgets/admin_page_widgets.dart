import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config.dart';

class AdminActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AdminActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.spMin),
        padding: EdgeInsets.all(6.spMin),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 18.spMin),
      ),
    );
  }
}

class AdminStatusBadge extends StatelessWidget {
  final bool isActive;
  final String? activeLabel;
  final String? inactiveLabel;

  const AdminStatusBadge({
    super.key,
    required this.isActive,
    this.activeLabel,
    this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    final label = isActive
        ? (activeLabel ?? 'ACTIVE')
        : (inactiveLabel ?? 'INACTIVE');
    final color = isActive ? Colors.green : Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 9.sp,
        ),
      ),
    );
  }
}
