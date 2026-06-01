import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../models/login/login_response_model.dart';
import '../../view models/controllers/login_view_model.dart';
import '../../view models/controllers/vendor_restaurant_view_model.dart';
import '../restaurant/restaurant_view.dart';
import 'profile_edit_view.dart';

/// Vendor profile — displays the logged-in vendor's account info
/// (name, email, phone, role, verification) pulled from local storage,
/// plus a link to their restaurant and a logout button.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    final vendor = Get.put(VendorRestaurantController());
    final LoginResponseModel? user = loginController.getUserInfo();

    return Scaffold(
      backgroundColor: kOffWhite,
      body: user == null
          ? Center(
              child: ReuseableText(
                text: 'Not logged in',
                fontSize: 14.spMin,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
            )
          : Column(
              children: [
                // Hero header — reference screenshot layout, styled
                // with the app's theme colors instead of navy.
                _ProfileHeader(user: user),

                // Scrollable details area.
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(14.r),
                    children: [
                      _sectionTitle('Account'),
                      _tile(Icons.person_outline, 'Username', user.username),
                      _tile(Icons.email_outlined, 'Email', user.email),
                      _tile(
                        Icons.phone_outlined,
                        'Phone',
                        user.phone.isEmpty ? '—' : user.phone,
                      ),
                      _tile(
                        Icons.verified_user_outlined,
                        'Email verified',
                        user.verification ? 'Yes' : 'No',
                      ),
                      _tile(
                        Icons.security_outlined,
                        'Phone verified',
                        user.phoneVerification ? 'Yes' : 'No',
                      ),
                      SizedBox(height: 16.h),

                      // Restaurant info
                      _sectionTitle('Restaurant'),
                      Obx(() {
                        final r = vendor.active;
                        if (r == null) {
                          return _tile(
                            Icons.storefront_outlined,
                            'Status',
                            'No restaurant',
                          );
                        }
                        return Column(
                          children: [
                            _tile(Icons.storefront, 'Name', r.title),
                            _tile(
                              Icons.verified_rounded,
                              'Verification',
                              r.verification,
                            ),
                            _tile(
                              r.isAvailable
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              'Open',
                              r.isAvailable ? 'Yes' : 'No',
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 16.h),

                      // Go to restaurant screen
                      GestureDetector(
                        onTap: () => Get.to(
                          () => const RestaurantScreen(),
                          transition: Transition.rightToLeft,
                        ),
                        child: Container(
                          height: 44.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ReuseableText(
                            text: 'Manage Restaurant',
                            fontSize: 13.spMin,
                            fontWeight: FontWeight.w600,
                            textColor: kLightWhite,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: loginController.logout,
                        child: Container(
                          height: 44.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: kRed),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ReuseableText(
                            text: 'Logout',
                            fontSize: 13.spMin,
                            fontWeight: FontWeight.w700,
                            textColor: kRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
        child: ReuseableText(
          text: t,
          fontSize: 12.spMin,
          fontWeight: FontWeight.w700,
          textColor: kGray,
        ),
      );

  Widget _tile(IconData icon, String label, String value) => Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: kOffWhite),
        ),
        child: Row(
          children: [
            Icon(icon, color: kPrimary, size: 18.spMin),
            SizedBox(width: 10.w),
            Expanded(
              child: ReuseableText(
                text: label,
                fontSize: 12.spMin,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
            ),
            ReuseableText(
              text: value,
              fontSize: 12.spMin,
              fontWeight: FontWeight.w600,
              textColor: kDark,
            ),
          ],
        ),
      );
}

/// Profile hero header — same layout as the design reference but
/// painted in the app's own palette (kSecondary / kPrimary) rather
/// than navy, so it blends with the rest of the vendor app.
class _ProfileHeader extends StatelessWidget {
  final LoginResponseModel user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Tighter left padding so the back arrow sits close to the edge,
      // matching standard iOS behavior.
      padding: EdgeInsets.fromLTRB(8.w, 14.h, 20.w, 22.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kSecondary, kSecondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row — iOS back chevron + "Profile" + edit pencil.
            // GestureDetector instead of IconButton so we don't inherit
            // the 48px padded tap target (which was pushing the title
            // far to the right).
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                    child: Icon(
                      CupertinoIcons.back,
                      color: kLightWhite,
                      size: 22.spMin,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ReuseableText(
                  text: 'Profile',
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.w800,
                  textColor: kLightWhite,
                ),
                const Spacer(),
                // Same edit icon used on the Restaurant screen's AppBar.
                GestureDetector(
                  onTap: () => Get.to(
                    () => const ProfileEditScreen(),
                    transition: Transition.rightToLeft,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    child: Icon(
                      Icons.edit_outlined,
                      color: kLightWhite,
                      size: 22.spMin,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            // Avatar + name + email row — padded so it lines up with
            // the ListView below (which uses 14 horizontal padding).
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Row(
                children: [
                  AppNetworkAvatar(
                    imageUrl: user.profile,
                    radius: 24.r,
                    fallbackAsset: const AssetImage(
                        'assets/smiling-redhaired-boy-illustration.png'),
                  ),
                  SizedBox(width: 10.spMin),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseableText(
                          text: user.username,
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.w700,
                          textColor: kLightWhite,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.spMin),
                        ReuseableText(
                          text: user.email,
                          fontSize: 11.spMin,
                          fontWeight: FontWeight.w400,
                          textColor: kLightWhite,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
