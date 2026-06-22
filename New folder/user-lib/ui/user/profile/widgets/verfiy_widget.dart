import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';

class VerificationAlert extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isVerified;
  final VoidCallback? onVerifyTap;

  const VerificationAlert({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isVerified,
    this.onVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.spMin),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withValues(alpha: .1)
            : Colors.orange.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isVerified
              ? Colors.green.withValues(alpha: .3)
              : Colors.orange.withValues(alpha: .3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.spMin),
            decoration: BoxDecoration(
              color: isVerified
                  ? Colors.green.withValues(alpha: .2)
                  : Colors.orange.withValues(alpha: .2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isVerified ? Colors.green : Colors.orange,
              size: 22.spMin,
            ),
          ),
          SizedBox(width: 12.spMin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isVerified)
            Icon(Icons.check_circle, color: Colors.green, size: 24.spMin)
          else
            GestureDetector(
              onTap: onVerifyTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.spMin,
                  vertical: 6.spMin,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
