import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/widgets/app_btn.dart';
import '../../../../../routes/route_name.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/utils.dart';

class RegisterButton extends StatelessWidget {
  final FocusNode btnNode;
  final GlobalKey<FormState> formKey;

  const RegisterButton({
    super.key,
    required this.btnNode,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.registerResponse.status == Status.error) {
          final message =
              state.registerResponse.message ?? 'Registration failed';
          ToastUtils.showError(
            context,
            message: message.isNotEmpty ? message : 'Registration failed',
          );
          return;
        }
        if (state.registerResponse.status == Status.success) {
          final message =
              state.registerResponse.message ??
              'Account created successfully! Please check your email for OTP verification.';
          ToastUtils.showSuccess(
            context,
            message: message.isNotEmpty
                ? message
                : 'Account created successfully! Please check your email for OTP verification.',
          );
          Navigator.pushReplacementNamed(context, RouteName.login);
          return;
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state.registerResponse.status == Status.loading;

          return AppButton(
            node: btnNode,
            width: double.infinity,
            text: 'Create Account',
            isLoading: isLoading,
            onPressed: () => _onPressed(context, state),
          );
        },
      ),
    );
  }

  void _onPressed(BuildContext context, RegisterState state) {
    if (formKey.currentState?.validate() ?? false) {
      context.read<RegisterBloc>().add(RegisterSubmitEvent());
    }
  }
}
