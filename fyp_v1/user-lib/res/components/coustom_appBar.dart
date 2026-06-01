// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: unused_import
import '../../models/address/address_respose_model.dart';
import '../../repository/hooks/fatch_all_address.dart';
import '../../repository/hooks/fetch_defult_address.dart';
import '../../view_models/controller/login/login_view_model.dart';
import '../../view_models/controller/user/user_view_model.dart';
import '../colors/app_color.dart';
import 'reuseable_text.dart';
import 'reuseable_text_2.dart';
import 'shimer/app_bar_shimer.dart';

class CustomAppBar extends HookWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(65.h);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final addressesList = useFetchAddress();

    final userInfoController = Get.put(UserInformation());
    userInfoController.fetchUserData();
    final hookResult = useDefaultAddress(context);
    final address = hookResult.data;
    final isLoading = hookResult.isLoading;
    final box = GetStorage();

    String? token = box.read('token');
    // print('$token : 222');
    if (token != null) {
      controller.getUserInfo();

      // print(user!.email);
      // print('$token : 333');
    }

    if (isLoading) {
      return const AppBarShimer();
    }

    // if (address == null) {
    //   showAddressSheet(context);
    // }
    // print(accessToken);
    // print(address);
    // print('image url :${userInfoController.imageUrl}');

    return Container(
      width: width,
      color: kOffWhite,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kOffWhite,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: kSecondary,
                    backgroundImage:
                        userInfoController.imageUrl.value.isNotEmpty
                            ? NetworkImage(userInfoController.imageUrl.value)
                            : const AssetImage('assets/1.jpg'),
                    // user!.profile != null
                    //     ? NetworkImage(user.profile.toString())
                    //     : const AssetImage('assets/1.jpg'),
                    radius: 22.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseableText(
                          text: 'Deliver to',
                          fontSize: 14.spMin,
                          textColor: kSecondary,
                        ),
                        ReuseableText2(
                          text: address != null
                              ?
                              // '${address.addressLine1}'
                              // ${address.district},
                              '${address.city},  ${address.postalCode}'
                              : 'Lahore',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          textColor: kDark,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              getTimeOfDay(),
              style: TextStyle(fontSize: 35.spMin),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return '❄️';
    } else if (hour >= 12 && hour < 16) {
      return '⛅️';
    } else {
      return '🌙';
    }
  }
}
