// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/login/login_response_model.dart';
import '../../../view models/controllers/login_view_model.dart';
import '../../../view models/controllers/vendor_restaurant_view_model.dart';
import '../../../views/profile/profile_view.dart';
import 'app_network_image.dart';
import 'reuseable_text.dart';

/// Home-screen header showing the logged-in vendor's avatar + name +
/// active restaurant address. Tapping the card opens the profile
/// screen. The Open/Closed toggle lives on the restaurant page's
/// cover image (not in this header).
class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    final vendor = Get.put(VendorRestaurantController());
    final LoginResponseModel? user = loginController.getUserInfo();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 0),
      child: Row(
        children: [
          // LEFT: tappable user card → profile
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.to(
                () => const ProfileScreen(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 250),
              ),
              child: Row(
                children: [
                  AppNetworkAvatar(
                    imageUrl: user?.profile,
                    radius: 22.spMin,
                    fallbackAsset: const AssetImage(
                        'assets/smiling-redhaired-boy-illustration.png'),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() {
                      final addr = vendor.active?.coords.address ?? '';
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReuseableText(
                            text: user?.username ?? 'Vendor',
                            fontSize: 13.spMin,
                            fontWeight: FontWeight.w700,
                            textColor: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Tight 1.h gap between name and address.
                          SizedBox(height: 1.h),
                          ReuseableText(
                            text: addr.isNotEmpty ? addr : 'No address yet',
                            fontSize: 10.spMin,
                            fontWeight: FontWeight.w400,
                            textColor: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          // The open-sign toggle moved to the cover image on the
          // restaurant page. No indicator needed in the home header.
        ],
      ),
    );
  }
}
