// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/user/forgot_password/forgot_password_bloc.dart';
import '../../../../../bloc/user/forgot_password/forgot_password_events.dart';
import '../../../../../bloc/user/forgot_password/forgot_password_state.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/enums.dart';

Widget buildSuccessContent(
  TextEditingController emailController,
  Animation<double> scaleAnimation,
  BuildContext context,
) {
  final colors = context.colors;

  return ScaleTransition(
    scale: scaleAnimation,
    child: Column(
      children: [
        AppSizes.verticalSpace3Xl,
        _buildSuccessIllustration(),
        AppSizes.verticalSpaceXxl,
        Text(
          'Check Your Email',
          style: AppTextStyles.displaySmall.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        AppSizes.verticalSpaceMd,
        Padding(
          padding: AppSizes.paddingHorizontalMd,
          child: Text(
            'We have sent a new temporary password to\n${emailController.text}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textSecondary,
              height: AppSizes.lineHeightNormal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        AppSizes.verticalSpaceMd,
        Padding(
          padding: AppSizes.paddingHorizontalMd,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.warning, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please change your password after logging in for security.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSizes.verticalSpace3Xl,
        AppSizes.verticalSpaceMd,
        _buildResendLink(),
      ],
    ),
  );
}

Widget _buildResendLink() {
  return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
    buildWhen: (previous, current) =>
        previous.forgotPasswordResponse.status !=
        current.forgotPasswordResponse.status,
    builder: (context, state) {
      final isLoading = state.forgotPasswordResponse.status == Status.loading;

      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the email? ",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<ForgotPasswordBloc>().add(
                        SubmitForgotPasswordEvent(),
                      );
                    },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                isLoading ? 'Sending...' : 'Resend',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isLoading
                      ? AppColors.textSecondary
                      : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildSuccessIllustration() {
  return Center(
    child: Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(AppSizes.spacingLg),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.4),
              blurRadius: AppSizes.shadowBlurXl,
              spreadRadius: AppSizes.shadowSpreadMd,
            ),
          ],
        ),
        child: Icon(
          Icons.mark_email_read_outlined,
          color: AppColors.textOnPrimary,
          size: 50,
        ),
      ),
    ),
  );
}
