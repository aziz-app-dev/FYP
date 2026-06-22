// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../bloc/user/login/login_events.dart';

// import '../../../../bloc/user/login/login_bloc.dart';
// import '../../../../bloc/user/login/login_state.dart';

// class PasswordWidget extends StatelessWidget {
//   const PasswordWidget({super.key, required this.passwordNode});

//   final FocusNode passwordNode;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         print("object");
//         return TextFormField(
//           focusNode: passwordNode,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hint: Text("Enter password"),
//           ),
//           onChanged: (value) {
//             return context.read<LoginBloc>().add(PassChangeEvent(value));
//           },
//           keyboardType: TextInputType.visiblePassword,
//           onFieldSubmitted: (value) {},
//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Enter Your password";
//             }
//             return null;
//           },
//         );
//       },
//     );
//   }
// }
