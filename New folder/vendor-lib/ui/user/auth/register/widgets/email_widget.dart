import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/input_utils.dart';

Widget buildEmailField(
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
        'Email',
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
      AppSizes.verticalSpaceXs,
      BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            focusNode: node,
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.bodyLarge,
            onChanged: (value) {
              context.read<RegisterBloc>().add(EmailChangedEvent(value));
            },
            decoration: InputDecoration(
              hintText: 'Enter your email',
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
  );
}
