import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';
import '../../../../config/widgets/app_btn.dart';
import '../../../../model/address/address_model.dart';
import '../../../../routes/route_name.dart';

class CheckoutAddressCard extends StatelessWidget {
  final AddressModel? selectedAddress;
  final VoidCallback onSwap;

  const CheckoutAddressCard({
    super.key,
    required this.selectedAddress,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (selectedAddress == null) {
      return AppButton(
        text: 'Add a delivery address',
        onPressed: () {
          Navigator.pushNamed(context, RouteName.addNewAddress);
        },
        icon: Icons.add,
      );
    }

    final address = selectedAddress!;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.spMin),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.spMin),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(
                  Icons.location_on,
                  color: colors.primary,
                  size: 20.spMin,
                ),
              ),
              SizedBox(width: 12.spMin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.addressType ?? 'Address',
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        if (address.isDefault) ...[
                          SizedBox(width: 8.spMin),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.spMin,
                              vertical: 2.spMin,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusXs,
                              ),
                            ),
                            child: Text(
                              'Default',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.spMin),
                    Text(
                      address.fullAddress,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: onSwap,
              //   child: Icon(
              //     Icons.swap_horiz_rounded,
              //     color: colors.primary,
              //     size: 22.spMin,
              //   ),
              // ),
            ],
          ),
        ),
        Positioned(
          right: 0,

          child: InkWell(
            onTap: onSwap,
            child: Container(
              padding: EdgeInsets.all(4.spMin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppSizes.radiusMd),
                  bottomLeft: Radius.circular(AppSizes.radiusLg),
                ),
                color: colors.primary,
              ),
              child: Icon(Icons.swap_horiz_rounded, size: 22.spMin),
            ),
          ),
        ),
      ],
    );
  }
}
