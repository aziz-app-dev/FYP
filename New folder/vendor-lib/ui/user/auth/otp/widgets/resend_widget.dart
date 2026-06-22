import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/bloc/user/otp_verification/otp_verification_bloc.dart';

import '../../../../../bloc/user/otp_verification/otp_verification_events.dart';
import '../../../../../bloc/user/otp_verification/otp_verification_state.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/toast_utils.dart';

Widget buildResendSection() {
  return Center(
    child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
      buildWhen: (previous, current) =>
          previous.canResend != current.canResend ||
          previous.resendSeconds != current.resendSeconds,
      builder: (context, state) {
        return Column(
          children: [
            Text(
              "Didn't receive the code?",
              style: TextStyle(
                fontSize: 14.spMin,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),

            if (state.canResend)
              TextButton(
                onPressed: () {
                  context.read<OtpVerificationBloc>().add(ResendOtpEvent());
                  ToastUtils.showOtpSent(
                    context,
                    phoneOrEmail: state.contactInfo,
                  );
                },
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 16.spMin,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend code in ',
                    style: TextStyle(
                      fontSize: 14.spMin,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${state.resendSeconds}s',
                      style: TextStyle(
                        fontSize: 14.spMin,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    ),
  );
}
