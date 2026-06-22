import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/user/forgot_password/forgot_password_bloc.dart';

import '../../../../../bloc/user/forgot_password/forgot_password_events.dart';
import '../../../../../bloc/user/forgot_password/forgot_password_state.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/input_utils.dart';

Widget buildEmailForm(
  FocusNode node,
  FocusNode nextNode,
  TextEditingController controller,
  GlobalKey<FormState> formKey,
  BuildContext context,
) {
  final colors = context.colors;

  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
        ),
        AppSizes.verticalSpaceXs,
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            return TextFormField(
              controller: controller,
              focusNode: node,
              keyboardType: TextInputType.emailAddress,
              style: AppTextStyles.bodyLarge,
              onChanged: (value) {
                context.read<ForgotPasswordBloc>().add(
                  EmailChangedEvent(value),
                );
              },
              decoration: InputDecoration(
                hintText: 'Enter your registered email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colors.textSecondary,
                ),
              ),
              onFieldSubmitted: (value) =>
                  InputUtils.fieldFocusChange(context, node, nextNode),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            );
          },
        ),
      ],
    ),
  );
}
