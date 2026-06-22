import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasSwitch;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.hasSwitch = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        color: colors.card,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.spMin,
            vertical: 12.spMin,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
          child: Row(
            spacing: 16.spMin,
            children: [
              Container(
                padding: EdgeInsets.all(10.spMin),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: colors.primary, size: 22.spMin),
              ),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (hasSwitch)
                Switch(
                  value: true,
                  onChanged: (v) {},
                  activeTrackColor: colors.primary.withValues(alpha: .3),
                  activeThumbColor: colors.primary,
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18.spMin,
                  color: colors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
