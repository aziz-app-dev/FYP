import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/input_utils.dart';

Widget buildPhoneField(
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
        'Phone',
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
      AppSizes.verticalSpaceXs,
      BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.phone != current.phone,
        builder: (context, state) {
          return TextFormField(
            focusNode: node,
            controller: controller,
            keyboardType: TextInputType.phone,
            style: AppTextStyles.bodyLarge,
            onChanged: (value) {
              context.read<RegisterBloc>().add(PhoneChangedEvent(value));
            },
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              prefixIcon: Icon(Icons.phone_outlined, color: colors.textSecondary),
            ),
            onFieldSubmitted: (value) =>
                InputUtils.fieldFocusChange(context, node, nextNode),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          );
        },
      ),
    ],
  );
}
