// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../models/user/user_update_request.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/coustom_button.dart';
import '../../res/components/reuseable_text.dart';
import '../../view_models/controller/user/user_view_model.dart';
import '../address/widgets/text_field.dart';

class ProfileUpdateScreen extends StatefulHookWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final userInfoController = Get.put(UserInformation());
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    userNameController.text = userInfoController.user!.username;
    phoneController.text = userInfoController.user!.phone;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kSecondary,
          centerTitle: true,
          title: const ReuseableText(
            text: "Update Profile",
            fontSize: 18,
            textColor: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Obx(
          () {
            if (userInfoController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userInfoController.error.isNotEmpty) {
              return Center(
                  child: Text('Error: ${userInfoController.error.value}'));
            }

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      Obx(() {
                        // print('object${userInfoController.imageUrl.value}');
                        return CircleAvatar(
                          backgroundColor: kSecondary,
                          backgroundImage: NetworkImage(
                              // imageUploadController.imageUrl.value.isEmpty
                              //     ? user.profile
                              //     :
                              userInfoController.imageUrl.value),
                          radius: 70.r,
                        );
                      }),
                      SizedBox(
                        height: 15.h,
                      ),
                      // Text(userInfoController.user!.username),
                      // Text(userInfoController.user!.email),
                      // Text(userInfoController.user!.phone),
                      // Text(userInfoController.user!.profile),
                      // Text(userInfoController.user!.username),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            userInfoController.pickImage().then((_) {
                              if (userInfoController
                                  .selectedImagePath!.value.isNotEmpty) {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialogWidget(
                                        imageUploadController:
                                            userInfoController);
                                  },
                                );
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_square,
                                size: 25.spMin,
                                color: kPrimary,
                              ),
                              // Icon(AntDesign.edit),
                              SizedBox(width: 10.w),
                              const ReuseableText(
                                text: 'Change Profile Image',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                textColor: kGray,
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ! user name field
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: const ReuseableText(
                              text: 'Complete Name',
                              fontSize: 15,
                              textColor: kGray,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AddressFormField(
                            controller: userNameController,
                            prefixIcon: const Icon(
                              AntDesign.user,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: const ReuseableText(
                              text: 'Mobile Number',
                              fontSize: 15,
                              textColor: kGray,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AddressFormField(
                            controller: phoneController,
                            prefixIcon: const Icon(
                              AntDesign.phone,
                              size: 20,
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 50.h),
                          CustomButton(
                            onTap: () {
                              UserUpdateRequestModel updatedUser =
                                  UserUpdateRequestModel(
                                      username: userNameController.text,
                                      phone: phoneController.text,
                                      profile:
                                          userInfoController.imageUrl.value);
                              var data =
                                  userUpdateRequestModelToJson(updatedUser);
                              userInfoController.updateUser(data);
                            },
                            btnHeight: 40.h,
                            btnWidth: width,
                            radius: 9.r,
                            child: const Center(
                                child: ReuseableText(
                              text: 'U P D A T E',
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

// !  AlertDialogWidget
class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    super.key,
    required this.imageUploadController,
  });

  final UserInformation imageUploadController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kOffWhite,
      title: const Center(
        child: ReuseableText(
          text: 'Confirm Upload',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          textColor: kGray,
        ),
      ),
      content: const ReuseableText(
        text: 'Do you want to upload this image',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        textColor: kGray,
      ),
      actions: [
        TextButton(
          child: const ReuseableText(
            text: 'Cancel',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            textColor: kRed,
          ),
          onPressed: () {
            Get.back(); // Close the dialog
          },
        ),
        TextButton(
          child: const ReuseableText(
            text: 'OK',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textColor: kPrimary,
          ),
          onPressed: () {
            Get.back(); // Close the dialog
            imageUploadController.uploadImageToCloudinary();
          },
        ),
      ],
    );
  }
}
