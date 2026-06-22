import 'package:food/ui/user/profile/view/0_all_profile_view.dart';

import '../../../../../bloc/user/login/login_bloc.dart';
import '../../../../../bloc/user/login/login_events.dart';
import '../../../../../bloc/user/login/login_state.dart';

class RememberMeAndForgot extends StatelessWidget {
  const RememberMeAndForgot({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Flexible(
        //   child: Row(
        //     children: [
        //       SizedBox(
        //         width: 24.spMin,
        //         height: 24.spMin,
        //         child: BlocBuilder<LoginBloc, LoginState>(
        //           buildWhen: (previous, current) =>
        //               previous.rememberMe != current.rememberMe,
        //           builder: (context, state) {
        //             return Checkbox(
        //               value: state.rememberMe,
        //               onChanged: (value) {
        //                 context.read<LoginBloc>().add(ToggleRememberMeEvent());
        //               },
        //             );
        //           },
        //         ),
        //       ),
        //       AppSizes.horizontalSpaceXs,
        //       Flexible(
        //         child: Text(
        //           'Remember me',
        //           style: AppTextStyles.bodyMedium.copyWith(
        //             color: colors.textSecondary,
        //           ),
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.forgotPassword);
          },
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
