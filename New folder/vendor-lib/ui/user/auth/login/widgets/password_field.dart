import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/user/login/login_bloc.dart';
import '../../../../../bloc/user/login/login_events.dart';
import '../../../../../bloc/user/login/login_state.dart';
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
      BlocBuilder<LoginBloc, LoginState>(
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
              context.read<LoginBloc>().add(PasswordChangedEvent(value));
            },
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock_outline, color: colors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  context.read<LoginBloc>().add(
                    TogglePasswordVisibilityEvent(),
                  );
                },
              ),
            ),
            onFieldSubmitted: (value) =>
                InputUtils.fieldFocusChange(context, node, nextNode),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          );
        },
      ),
    ],
  );
}
