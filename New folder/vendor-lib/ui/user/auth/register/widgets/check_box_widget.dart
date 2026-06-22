import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/config.dart';

Widget buildTermsCheckbox(BuildContext context) {
  final colors = context.colors;
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
                  previous.termsAccepted != current.termsAccepted,
              builder: (context, state) {
                return Checkbox(
                  value: state.termsAccepted,
                  onChanged: (value) => context
                      .read<RegisterBloc>()
                      .add(ToggleTermsAcceptedEvent()),
                );
              },
            ),
          ),
          AppSizes.horizontalSpaceXs,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      AppSizes.verticalSpaceSm,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
                  previous.privacyPolicyAccepted !=
                  current.privacyPolicyAccepted,
              builder: (context, state) {
                return Checkbox(
                  value: state.privacyPolicyAccepted,
                  onChanged: (value) => context
                      .read<RegisterBloc>()
                      .add(TogglePrivacyPolicyAcceptedEvent()),
                );
              },
            ),
          ),
          AppSizes.horizontalSpaceXs,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
