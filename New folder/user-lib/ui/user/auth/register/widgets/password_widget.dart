import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/input_utils.dart';

Widget buildPasswordField(
  FocusNode node,
  FocusNode nextNode,
  TextEditingController controller,
  BuildContext context,
) {
  final colors = context.colors;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Password',
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
      AppSizes.verticalSpaceXs,

      BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.isPasswordVisible != current.isPasswordVisible,
        builder: (context, state) {
          return TextFormField(
            focusNode: node,
            controller: controller,
            obscureText: !state.isPasswordVisible,
            style: AppTextStyles.bodyLarge,
            onChanged: (value) {
              context.read<RegisterBloc>().add(PasswordChangedEvent(value));
            },
            decoration: InputDecoration(
              hintText: 'Create a password',
              prefixIcon: Icon(Icons.lock_outline, color: colors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  !state.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  context.read<RegisterBloc>().add(
                    TogglePasswordVisibilityEvent(),
                  );
                },
              ),
            ),
            onFieldSubmitted: (value) =>
                InputUtils.fieldFocusChange(context, node, nextNode),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          );
        },
      ),
    ],
  );
}

Widget buildConfirmPasswordField(
  FocusNode node,
  FocusNode nextNode,
  TextEditingController controller,
  BuildContext context,
) {
  final colors = context.colors;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Confirm Password',
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
      AppSizes.verticalSpaceXs,
      BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) =>
            previous.confirmPassword != current.confirmPassword ||
            previous.isConfirmPasswordVisible !=
                current.isConfirmPasswordVisible,
        builder: (context, state) {
          return TextFormField(
            controller: controller,
            focusNode: node,
            obscureText: !state.isConfirmPasswordVisible,
            style: AppTextStyles.bodyLarge,
            onChanged: (value) {
              context.read<RegisterBloc>().add(
                ConfirmPasswordChangedEvent(value),
              );
            },
            decoration: InputDecoration(
              hintText: 'Confirm your password',
              prefixIcon: Icon(Icons.lock_outline, color: colors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colors.textSecondary,
                ),

                onPressed: () {
                  context.read<RegisterBloc>().add(
                    ToggleConfirmPasswordVisibilityEvent(),
                  );
                },
              ),
            ),
            onFieldSubmitted: (value) =>
                InputUtils.fieldFocusChange(context, node, nextNode),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }

              return null;
            },
          );
        },
      ),
    ],
  );
}
