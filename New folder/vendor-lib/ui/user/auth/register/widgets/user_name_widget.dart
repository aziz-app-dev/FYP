import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/config.dart';

Widget buildUsernameField(
  FocusNode node,
  TextEditingController controller,
  BuildContext context,
) {
  final colors = context.colors;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Username',
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
      AppSizes.verticalSpaceXs,
      BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.username != current.username,
        builder: (context, state) {
          return TextFormField(
            controller: controller,
            focusNode: node,
            style: AppTextStyles.bodyLarge,
            onChanged: (value) {
              context.read<RegisterBloc>().add(UsernameChangedEvent(value));
            },
            decoration: InputDecoration(
              hintText: 'Enter your username',
              prefixIcon: Icon(
                Icons.person_outline,
                color: colors.textSecondary,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          );
        },
      ),
    ],
  );
}
