import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/res_imports.dart';
import '../../core/enums/user_type.dart';
import '../../view_models/controller/account_switcher/account_switcher_controller.dart';
import 'widgets/account_mode_tile.dart';

/// Bottom sheet for switching between Customer and Vendor account modes
class AccountSwitcherBottomSheet extends StatelessWidget {
  const AccountSwitcherBottomSheet({
    super.key,
    this.onModeChanged,
  });

  final Function(UserType)? onModeChanged;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountSwitcherController>(
      init: Get.find<AccountSwitcherController>(),
      builder: (controller) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: kGrayLight,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                'Switch Account Mode',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: kDark,
                ),
              ),
              SizedBox(height: 8.h),

              Text(
                'Choose how you want to use the app',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: kGray,
                ),
              ),
              SizedBox(height: 24.h),

              // Customer Mode Tile
              Obx(() => AccountModeTile(
                    title: 'Customer Mode',
                    subtitle: 'Browse and order food from restaurants',
                    icon: Icons.shopping_bag_outlined,
                    isSelected: controller.isCustomerMode,
                    onTap: () {
                      controller.switchToCustomerMode();
                      onModeChanged?.call(UserType.customer);
                      Get.back();
                    },
                  )),

              SizedBox(height: 12.h),

              // Vendor Mode Tile
              Obx(() => AccountModeTile(
                    title: 'Vendor Mode',
                    subtitle: 'Manage your restaurant and orders',
                    icon: Icons.store_outlined,
                    isSelected: controller.isVendorMode,
                    isEnabled: controller.canSwitchToVendor,
                    onTap: () {
                      if (controller.switchToVendorMode()) {
                        onModeChanged?.call(UserType.vendor);
                        Get.back();
                      }
                    },
                  )),

              // Info message for non-vendors
              Obx(() {
                if (!controller.canSwitchToVendor) {
                  return Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: kSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kSecondary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Register as a vendor to access vendor features and manage your restaurant.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: kDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  /// Show the account switcher bottom sheet
  static void show({Function(UserType)? onModeChanged}) {
    Get.bottomSheet(
      AccountSwitcherBottomSheet(onModeChanged: onModeChanged),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
