import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/utils/toast_utils.dart';

import '../../../../../bloc/user/login/login_bloc.dart';
import '../../../../../bloc/user/login/login_events.dart';
import '../../../../../bloc/user/login/login_state.dart';
import '../../../../../config/widgets/app_btn.dart';
import '../../../../../routes/route_name.dart';
import '../../../../../services/session/session_manger.dart';
import '../../../../../utils/enums.dart';

class LoginButton extends StatelessWidget {
  final FocusNode btnNode;
  final GlobalKey<FormState> formKey;

  const LoginButton({super.key, required this.btnNode, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.loginResponse.status == Status.error) {
          debugPrint(state.loginResponse.message);
          ToastUtils.showError(
            context,
            message: "${state.loginResponse.message}",
          );
        }
        if (state.loginResponse.status == Status.success) {
          debugPrint(state.loginResponse.message);
          ToastUtils.showInfo(
            context,
            message: "${state.loginResponse.message}",
          );
          final session = SessionManager();
          final nextRoute = session.isAdmin
              ? RouteName.adminMain
              : session.isVendor
                  ? RouteName.vendorDashboard
                  : session.isDriver
                      ? RouteName.driverMain
                      : RouteName.mainScreen;
          Navigator.pushReplacementNamed(context, nextRoute);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            previous.loginResponse.status != current.loginResponse.status,
        // previous.loginResponse.status != previous.loginResponse.status,
        builder: (context, state) {
          return AppButton(
            width: double.infinity,
            node: btnNode,
            text: 'Sign In',
            isLoading: state.loginResponse.status == Status.loading,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (formKey.currentState?.validate() ?? false) {
                context.read<LoginBloc>().add(LoginSubmitEvent());
              }
            },
          );
        },
      ),
    );
  }
}
