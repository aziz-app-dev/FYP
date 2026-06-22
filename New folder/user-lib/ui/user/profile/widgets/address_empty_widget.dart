// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../bloc/user/address/address_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../bloc/user/address/address_event.dart';
import '../../../../bloc/user/address/address_state.dart';
import '../../../../config/config.dart';
import '../../../../config/widgets/app_btn.dart';
import '../../../../routes/route_name.dart';

Widget addressEmptyState(BuildContext context, ThemeColors colors) {
  return Center(
    child: Padding(
      padding: AppSizes.paddingAllLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/Location Lottie Animation.json',
            width: 150.spMin,
            height: 150.spMin,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.spMin),
          Text(
            'No Addresses Yet',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.spMin),
          Text(
            'Add your first delivery address\nto start ordering',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 32.spMin),
          BlocBuilder<AddressBloc, AddressState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return AppButton(
                text: 'Add Address',
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.addNewAddress).then(
                    (_) =>
                        context.read<AddressBloc>().add(LoadAddressesEvent()),
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
