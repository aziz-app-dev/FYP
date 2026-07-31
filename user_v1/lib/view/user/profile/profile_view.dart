import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../view_models/controller/account_switcher/account_switcher_controller.dart';
import '../../account_switcher/account_switcher_bottom_sheet.dart';
import '../../vendor/home/vendor_home_view.dart';
import '../../../models/login/login_respose_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/coustom_button.dart';
import '../../../res/components/profile_app_bar.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../res/routes/routes_name.dart';
import '../../../view_models/controller/cart/cart_view_model.dart';
import '../../../view_models/controller/login/login_view_model.dart';
import '../../../view_models/controller/user/user_view_model.dart';
import '../auth/login/login_redirect.dart';
import '../auth/varification/varification_view.dart';
import 'widgets/profile_tile_widget.dart';
import 'widgets/user_info_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    LoginResponseModel? user;
    final controller = Get.put(LoginController());
    final cartController = Get.put(CartController());
    final userInfoController = Get.put(UserInformation());
    userInfoController.fetchUserData();
    cartController.fetchCartCount();

    final box = GetStorage();

    String? token = box.read('token');
    // print('$token : 222');
    if (token != null) {
      user = controller.getUserInfo();

      // print(user!.email);
      // print('$token : 333');
    }

    if (token == null) {
      return const LoginRedirect();
    }

    if (user != null && user.verification == false) {
      return const VerificationScreen();
    }
    // final LocationService locationService = LocationService();
    // final AddressService addressService = AddressService();

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: const ProfileAAppBar()),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            color: kOffWhite,
            child: Column(
              children: [
                UserInformationWidget(
                  user: user,
                ),

                SizedBox(height: 10.h),
                // !
                Container(
                  height: 190.h,
                  // width: width,
                  decoration: const BoxDecoration(
                    color: kLightWhite,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ProfileTileWidget(
                        onTap: () {
                          Get.toNamed(RouteName.UserOrderScreen);
                        },
                        title: 'My Orders',
                        icon: Ionicons.fast_food_outline,
                      ),
                      ProfileTileWidget(
                        onTap: () {},
                        title: 'My Favorite',
                        icon: Ionicons.heart_outline,
                      ),
                      ProfileTileWidget(
                        onTap: () {},
                        title: 'Reviews',
                        icon: Ionicons.chatbubble_outline,
                      ),
                      ProfileTileWidget(
                        onTap: () {},
                        title: 'Coupons',
                        icon: MaterialCommunityIcons.tag_outline,
                      ),
                    ],
                  ),
                ),
                // !
                SizedBox(height: 15.h),
                Container(
                  height: 190.h,
                  // width: width,
                  decoration: const BoxDecoration(
                    color: kLightWhite,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ProfileTileWidget(
                        onTap: () {
                          Get.toNamed(RouteName.ShippingAddressScreen);
                        },

                        // !
                        title: 'Shopping Address',
                        icon: SimpleLineIcons.location_pin,
                      ),
                      ProfileTileWidget(
                        onTap: () {},
                        title: 'Service Center',
                        icon: AntDesign.customerservice,
                      ),
                      ProfileTileWidget(
                        onTap: () {},
                        title: 'App FeedBack',
                        icon: MaterialIcons.rss_feed,
                      ),
                      ProfileTileWidget(
                        onTap: () {},
                        title: 'Settings',
                        icon: AntDesign.setting,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                // Account Switcher Section
                Container(
                  decoration: const BoxDecoration(
                    color: kLightWhite,
                  ),
                  child: ProfileTileWidget(
                    onTap: () {
                      AccountSwitcherBottomSheet.show(
                        onModeChanged: (mode) {
                          final accountController =
                              Get.find<AccountSwitcherController>();
                          if (accountController.isVendorMode) {
                            Get.offAll(() => const VendorHomeView());
                          }
                        },
                      );
                    },
                    title: 'Switch to Vendor Mode',
                    icon: Icons.swap_horiz,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomButton(
                  onTap: () {
                    controller.logout();
                  },
                  btnColor: kRed,
                  btnHeight: 30.h,
                  btnWidth: width,
                  radius: 0,
                  child: const Center(
                    child: ReuseableText(
                      text: 'Logout',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      textColor: kWhite,
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
