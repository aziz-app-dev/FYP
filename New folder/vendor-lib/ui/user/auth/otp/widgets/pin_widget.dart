import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/bloc/user/otp_verification/otp_verification_state.dart';
import 'package:pinput/pinput.dart';

import '../../../../../bloc/user/otp_verification/otp_verification_bloc.dart';
import '../../../../../bloc/user/otp_verification/otp_verification_events.dart';
import '../../../../../config/config.dart';

Widget buildPinInput(TextEditingController pinController, FocusNode focusNode) {
  final defaultPinTheme = PinTheme(
    width: 52.w,
    height: 56.h,
    textStyle: TextStyle(
      fontSize: 24.spMin,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.border),
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      border: Border.all(color: AppColors.secondary, width: 2),
      boxShadow: [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: 0.2),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    ),
  );

  final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      color: AppColors.secondary.withValues(alpha: 0.1),
      border: Border.all(color: AppColors.secondary),
    ),
  );

  final errorPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      border: Border.all(color: AppColors.error, width: 2),
    ),
  );

  return Center(
    child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return Pinput(
          length: 6,
          controller: pinController,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          pinAnimationType: PinAnimationType.fade,
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.easeInOut,
          showCursor: true,
          cursor: Container(
            width: 2.w,
            height: 24.h,
            color: AppColors.secondary,
          ),
          onCompleted: (pin) {
            context.read<OtpVerificationBloc>().add(OtpChangedEvent(pin));
            context.read<OtpVerificationBloc>().add(VerifyOtpEvent());
          },
          onChanged: (value) {
            context.read<OtpVerificationBloc>().add(OtpChangedEvent(value));
            if (value.length == 6) {
              focusNode.unfocus();
            }
          },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
        );
      },
    ),
  );
}
