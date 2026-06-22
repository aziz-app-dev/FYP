// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/address/address_bloc.dart';
import 'package:food/config/widgets/app_btn.dart';

import '../../../../bloc/user/address/address_event.dart';
import '../../../../bloc/user/address/address_state.dart';
import '../../../../routes/route_name.dart';

Widget buildAddButton(BuildContext context) {
  return BlocBuilder<AddressBloc, AddressState>(
    buildWhen: (previous, current) => false,
    builder: (context, state) {
      return AppButton(
        text: 'Add New Address',
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteName.addNewAddress,
          ).then((_) => context.read<AddressBloc>().add(LoadAddressesEvent()));
        },
      );
    },
  );
}
