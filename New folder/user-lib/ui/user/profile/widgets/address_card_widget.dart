// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../bloc/user/address/address_bloc.dart';

import '../../../../bloc/user/address/address_event.dart';
import '../../../../bloc/user/address/address_state.dart';
import '../../../../config/config.dart';
import '../../../../model/address/address_model.dart';
import '../../../../routes/route_name.dart';

Widget buildAddressCard(
  BuildContext context,
  AddressModel address,
  ThemeColors colors,
) {
  return BlocBuilder<AddressBloc, AddressState>(
    buildWhen: (previous, current) =>
        previous.isBusy != current.isBusy ||
        previous.selectedAddress != current.selectedAddress,
    builder: (context, state) {
      final isDefault = address.isDefault;
      final isSelected = state.selectedAddress?.id == address.id;
      final isBusy = state.isBusy;

      return GestureDetector(
        onTap: () {
          if (!isBusy && !isDefault) {
            _showSetDefaultConfirmation(context, address);
          }
        },
        child: Container(
          padding: EdgeInsets.all(10.spMin),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: isDefault
                ? Border.all(color: colors.primary, width: 1.5)
                : Border.all(color: colors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: .03),
                blurRadius: 15.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(15.spMin),
                decoration: BoxDecoration(
                  color: isDefault
                      ? colors.primary.withValues(alpha: .1)
                      : colors.scaffoldBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: isDefault ? colors.primary : colors.textSecondary,
                  size: 24.spMin,
                ),
              ),
              SizedBox(width: 10.spMin),

              // Address Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      address.addressLine1,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.spMin),
                    Text(
                      '${address.district}, ${address.province}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (address.postalCode.isNotEmpty) ...[
                      SizedBox(height: 2.spMin),
                      Text(
                        address.postalCode,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textHint,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Right side: Default badge and more button aligned together
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDefault)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.spMin,
                        vertical: 4.spMin,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Default',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    menuPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert, color: colors.textSecondary),
                    color: colors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabled: !isBusy,
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          Navigator.pushNamed(
                            context,
                            RouteName.addNewAddress,
                            arguments: address,
                          ).then(
                            (_) => context.read<AddressBloc>().add(
                              LoadAddressesEvent(),
                            ),
                          );
                          break;
                        case 'delete':
                          _showDeleteConfirmation(context, address);
                          break;
                        case 'default':
                          _showSetDefaultConfirmation(context, address);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 20.spMin,
                              color: colors.textPrimary,
                            ),
                            SizedBox(width: 12.spMin),
                            Text(
                              'Edit',
                              style: TextStyle(color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      if (!isDefault)
                        PopupMenuItem(
                          value: 'default',
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 20.spMin,
                                color: colors.primary,
                              ),
                              SizedBox(width: 12.spMin),
                              Text(
                                'Set as Default',
                                style: TextStyle(color: colors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20.spMin,
                              color: colors.error,
                            ),
                            SizedBox(width: 12.spMin),
                            Text(
                              'Delete',
                              style: TextStyle(color: colors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showDeleteConfirmation(BuildContext context, AddressModel address) {
  final colors = context.colors;
  final addressBloc = context.read<AddressBloc>();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: colors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        'Delete Address',
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this address?',
        style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            if (address.id != null) {
              addressBloc.add(DeleteAddressEvent(address.id!));
            }
          },
          child: Text('Delete', style: TextStyle(color: colors.error)),
        ),
      ],
    ),
  );
}

void _showSetDefaultConfirmation(BuildContext context, AddressModel address) {
  final colors = context.colors;
  final addressBloc = context.read<AddressBloc>();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: colors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        'Set as Default',
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        'Make this your default delivery address?',
        style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            if (address.id != null) {
              addressBloc.add(SetDefaultAddressEvent(address.id!));
            }
          },
          child: Text('Confirm', style: TextStyle(color: colors.primary)),
        ),
      ],
    ),
  );
}
