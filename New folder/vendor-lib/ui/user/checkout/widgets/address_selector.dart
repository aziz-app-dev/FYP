import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';
import '../../../../model/address/address_model.dart';

class AddressSelector {
  static void show({
    required BuildContext context,
    required List<AddressModel> addresses,
    required AddressModel? selectedAddress,
    required ValueChanged<AddressModel> onSelected,
  }) {
    final colors = context.colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radius3Xxl),
        ),
      ),
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.spMin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Address',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 16.spMin),
            ...addresses.map(
              (address) => GestureDetector(
                onTap: () {
                  onSelected(address);
                  Navigator.pop(ctx);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.spMin),
                  padding: EdgeInsets.all(16.spMin),
                  decoration: BoxDecoration(
                    color: selectedAddress?.id == address.id
                        ? colors.primary.withValues(alpha: 0.05)
                        : colors.background,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                      color: selectedAddress?.id == address.id
                          ? colors.primary
                          : colors.divider,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: selectedAddress?.id == address.id
                            ? colors.primary
                            : colors.textSecondary,
                      ),
                      SizedBox(width: 12.spMin),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.addressType ?? 'Address',
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              address.fullAddress,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (selectedAddress?.id == address.id)
                        Icon(Icons.check_circle, color: colors.primary),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.spMin),
          ],
        ),
      ),
    );
  }
}
