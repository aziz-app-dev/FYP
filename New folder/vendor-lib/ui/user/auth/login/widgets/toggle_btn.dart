import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/user/login/login_bloc.dart';
import '../../../../../bloc/user/login/login_events.dart';
import '../../../../../bloc/user/login/login_state.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/enums.dart';

class UserTypeWidgt extends StatelessWidget {
  const UserTypeWidgt({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(AppSizes.spacingXxs),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.userType != current.userType,
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  context: context,
                  label: 'User',
                  icon: Icons.person_outline,
                  isSelected: state.userType == UserType.user,
                  onTap: () {
                    context.read<LoginBloc>().add(
                      const UserTypeChangedEvent(0),
                    );
                  },
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  context: context,
                  label: 'Vendor',
                  icon: Icons.store_outlined,
                  isSelected: state.userType == UserType.vendor,
                  onTap: () {
                    context.read<LoginBloc>().add(
                      const UserTypeChangedEvent(1),
                    );
                  },
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  context: context,
                  label: 'Driver',
                  icon: Icons.delivery_dining_outlined,
                  isSelected: state.userType == UserType.driver,
                  onTap: () {
                    context.read<LoginBloc>().add(
                      const UserTypeChangedEvent(2),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildToggleButton({
  required BuildContext context,
  required String label,
  required IconData icon,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final colors = context.colors;

  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingSm,
        horizontal: AppSizes.paddingMd,
      ),
      decoration: BoxDecoration(
        gradient: isSelected ? colors.primaryGradient : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.3),
                  blurRadius: AppSizes.shadowBlurSm,
                  spreadRadius: AppSizes.shadowSpreadSm,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? colors.textOnPrimary : colors.textSecondary,
            size: AppSizes.iconMd,
          ),
          AppSizes.horizontalSpaceXs,
          Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(
              color: isSelected ? colors.textOnPrimary : colors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
