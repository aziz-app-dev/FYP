// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../bloc/user/login/login_bloc.dart';
// import '../../../../bloc/user/login/login_events.dart';
// import '../../../../bloc/user/login/login_state.dart';
// import '../../../../utils/enums.dart';

// class BtnWidget extends StatelessWidget {
//   final FocusNode btnNode;
//   final GlobalKey<FormState> formKey;

//   const BtnWidget({super.key, required this.btnNode, required this.formKey});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state.apiStatus == ApiStatus.loading) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(SnackBar(content: Text("Loading...")));
//         }
//         if (state.apiStatus == ApiStatus.failure) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(SnackBar(content: Text(state.msg)));
//         }
//         if (state.apiStatus == ApiStatus.success) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(SnackBar(content: Text(state.msg)));
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         buildWhen: (previous, current) =>
//             previous.apiStatus != current.apiStatus,
//         builder: (context, state) {
//           return SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               focusNode: btnNode,
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   context.read<LoginBloc>().add(LoginBtnEvent());
//                 }
//               },
//               child: Text("Login"),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
