// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../bloc/user/login/login_bloc.dart';
// import '../../../../bloc/user/login/login_events.dart';
// import '../../../../bloc/user/login/login_state.dart';

// class EmailWidget extends StatelessWidget {
//   const EmailWidget({super.key, required this.emailNode});

//   final FocusNode emailNode;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.email != current.email,
//       builder: (context, state) {
//         return TextFormField(
//           focusNode: emailNode,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hint: Text("Enter Email"),
//           ),
//           onChanged: (value) {
//             return context.read<LoginBloc>().add(EmailChangeEvent(value));
//           },
//           keyboardType: TextInputType.emailAddress,
//           onFieldSubmitted: (value) {},
//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Enter Your email";
//             }
//             return null;
//           },
//         );
//       },
//     );
//   }
// }
