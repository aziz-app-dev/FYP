import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/user/forgot_password/forgot_password_bloc.dart';
import '../../../../../bloc/user/forgot_password/forgot_password_events.dart';
import '../../../../../bloc/user/forgot_password/forgot_password_state.dart';
import '../../../../../config/widgets/app_btn.dart';
import '../../../../../utils/enums.dart';

Widget buildSendButton(FocusNode node, GlobalKey<FormState> formKey) {
  return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
    buildWhen: (previous, current) =>
        previous.forgotPasswordResponse.status !=
        current.forgotPasswordResponse.status,
    builder: (context, state) {
      final isLoading = state.forgotPasswordResponse.status == Status.loading;
      return AppButton(
        width: double.infinity,
        node: node,
        text: 'Send New Password',
        isLoading: isLoading,
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            context.read<ForgotPasswordBloc>().add(SubmitForgotPasswordEvent());
          }
        },
        icon: Icons.send,
      );
    },
  );
}
