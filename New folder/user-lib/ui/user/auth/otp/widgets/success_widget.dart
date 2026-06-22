import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../bloc/user/otp_verification/otp_verification_bloc.dart';
import '../../../../../bloc/user/otp_verification/otp_verification_state.dart';
import '../../../../../config/theme/app_colors.dart';
import 'continue_btn_widget.dart';

Widget buildSuccessContent(Animation<double> scale, BuildContext context) {
  return ScaleTransition(
    scale: scale,
    child: Column(
      children: [
        SizedBox(height: 60.h),
        _buildSuccessIllustration(),
        SizedBox(height: 32.h),
        Text(
          'Verified!',
          style: TextStyle(
            fontSize: 32.spMin,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
            builder: (context, state) {
              return Text(
                state.verificationType == VerificationType.phone
                    ? 'Your phone number has been verified successfully.'
                    : 'Your email has been verified successfully.',
                style: TextStyle(
                  fontSize: 16.spMin,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        SizedBox(height: 48.h),
        buildContinueButton(context),
      ],
    ),
  );
}

Widget _buildSuccessIllustration() {
  return Center(
    child: Container(
      width: 160.w,
      height: 160.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.2),
            AppColors.secondaryLight.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          Icons.check,
          color: AppColors.textOnPrimary,
          size: 56.spMin,
        ),
      ),
    ),
  );
}
