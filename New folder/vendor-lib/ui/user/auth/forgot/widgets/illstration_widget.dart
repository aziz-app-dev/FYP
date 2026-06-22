import 'package:flutter/material.dart';
import '../../../../../config/config.dart';

Widget buildIllustration(BuildContext context) {
  final colors = context.colors;

  return Center(
    child: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: AppSizes.shadowBlurXl,
                  spreadRadius: AppSizes.shadowSpreadSm,
                ),
              ],
            ),
            child: Icon(
              Icons.email_outlined,
              color: AppColors.primary,
              size: 60,
            ),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryAccent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.4),
                    blurRadius: AppSizes.shadowBlurSm,
                  ),
                ],
              ),
              child: Icon(
                Icons.key,
                color: colors.textOnPrimary,
                size: AppSizes.iconMd,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
