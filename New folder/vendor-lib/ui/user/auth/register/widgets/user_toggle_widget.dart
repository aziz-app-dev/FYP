import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/register/register_state.dart';

import '../../../../../bloc/user/register/register_bloc.dart';
import '../../../../../bloc/user/register/register_events.dart';
import '../../../../../config/config.dart';
import '../../../../../utils/enums.dart';

Widget buildUserTypeToggle(BuildContext context) {
  final colors = context.colors;

  return Container(
    padding: EdgeInsets.all(AppSizes.spacingXxs),
    decoration: BoxDecoration(
      color: colors.background,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      border: Border.all(color: colors.border),
    ),
    child: BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.userType != current.userType,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                label: 'User',
                icon: Icons.person_outline,
                description: 'Order food',
                isSelected: state.userType == UserType.user,
                onTap: () => context.read<RegisterBloc>().add(
                  UserTypeEvent(UserType.user),
                ),
                color: AppColors.primary,
                context: context,
              ),
            ),
            Expanded(
              child: _buildToggleButton(
                label: 'Vendor',
                icon: Icons.store_outlined,
                description: 'Sell food',
                isSelected: state.userType == UserType.vendor,
                onTap: () => context.read<RegisterBloc>().add(
                  UserTypeEvent(UserType.vendor),
                ),
                color: AppColors.secondary,
                context: context,
              ),
            ),
            Expanded(
              child: _buildToggleButton(
                label: 'Driver',
                icon: Icons.delivery_dining_outlined,
                description: 'Deliver orders',
                isSelected: state.userType == UserType.driver,
                onTap: () => context.read<RegisterBloc>().add(
                  UserTypeEvent(UserType.driver),
                ),
                color: const Color(0xFF2E5BFF),
                context: context,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildToggleButton({
  required String label,
  required IconData icon,
  required String description,
  required bool isSelected,
  required VoidCallback onTap,
  required Color color,
  required BuildContext context,
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
        gradient: isSelected
            ? LinearGradient(colors: [color, color.withValues(alpha: 0.8)])
            : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: AppSizes.shadowBlurSm,
                  spreadRadius: AppSizes.shadowSpreadSm,
                ),
              ]
            : null,
      ),
      child: Row(
        spacing: AppSizes.spacingXxs,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? colors.textOnPrimary : colors.textSecondary,
            size: AppSizes.iconXxl,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.titleSmall.copyWith(
                  color: isSelected
                      ? colors.textOnPrimary
                      : colors.textSecondary,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? colors.textOnPrimary : colors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
