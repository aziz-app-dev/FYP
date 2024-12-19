import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../models/login/login_respose_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../view_models/controller/user/user_view_model.dart';
import '../user_profile_edit.dart';

class UserInformationWidget extends StatelessWidget {
  const UserInformationWidget({super.key, this.user});
  final LoginResponseModel? user;
  @override
  Widget build(BuildContext context) {
    final userInfoController = Get.put(UserInformation());
    // print(user!.profile.toString());
    return Container(
      height: height * 0.06,
      width: width,
      color: kLightWhite,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: CircleAvatar(
                    backgroundColor: kSecondary,
                    backgroundImage:
                        userInfoController.imageUrl.value.isNotEmpty
                            ? NetworkImage(userInfoController.user!.profile)
                            // ? NetworkImage(userInfoController.imageUrl.value)
                            : const AssetImage('assets/1.jpg'),
                    // NetworkImage(userInfoController.imageUrl.value),
                    // NetworkImage(userInfoController.imageUrl.value),
                    radius: 20.r,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Padding(
                  padding: EdgeInsets.all(4.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseableText(
                        text: user!.username,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        textColor: kGray,
                      ),
                      ReuseableText(
                        text: user!.email,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: kGray,
                      ),
                    ],
                  ),
                )
              ],
            ),
            // const Icon(AntDesign.edit)
            GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileUpdateScreen());
                },
                child: const Icon(AntDesign.edit))
          ],
        ),
      ),
    );
  }
}
