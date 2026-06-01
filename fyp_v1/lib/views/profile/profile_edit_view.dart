import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/app_back_button.dart';
import '../../common/res/components/app_network_image.dart';
import '../../common/res/components/coustom_button.dart';
import '../../common/res/components/coustom_textformfield.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/utils/utils.dart';
import '../../models/login/login_response_model.dart';
import '../../view models/controllers/login_view_model.dart';
import '../../view models/controllers/profile_edit_view_model.dart';
import '../../view models/controllers/uploader_view_model.dart';

/// Edit the logged-in vendor's own account info — avatar, username,
/// and phone number. Email and role aren't editable.
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _login = Get.put(LoginController());
  final _uploader = Get.put(UploaderController());
  final _edit = Get.put(ProfileEditController());

  late final TextEditingController _username;
  late final TextEditingController _phone;
  LoginResponseModel? _user;

  @override
  void initState() {
    super.initState();
    _user = _login.getUserInfo();
    _username = TextEditingController(text: _user?.username ?? '');
    _phone = TextEditingController(text: _user?.phone ?? '');
    // Seed the uploader with the existing avatar so the widget shows it.
    _uploader.setLogoUrl = _user?.profile ?? '';
  }

  @override
  void dispose() {
    _username.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_username.text.trim().isEmpty) {
      Utils.showWarning('Missing', 'Username is required.');
      return;
    }
    final ok = await _edit.save(
      username: _username.text.trim(),
      phone: _phone.text.trim(),
      profileUrl: _uploader.logoUrl.isNotEmpty
          ? _uploader.logoUrl
          : (_user?.profile ?? ''),
    );
    if (ok && mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kSecondary,
        centerTitle: true,
        leading: const AppBackButton(),
        title: ReuseableText(
          text: 'Edit Profile',
          fontSize: 16.spMin,
          fontWeight: FontWeight.w600,
          textColor: kWhite,
        ),
      ),
      body: _user == null
          ? Center(
              child: ReuseableText(
                text: 'Not logged in',
                fontSize: 14.spMin,
                fontWeight: FontWeight.w500,
                textColor: kGray,
              ),
            )
          : ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // Avatar picker — tap to pick + upload via UploaderController.
                Center(
                  child: GestureDetector(
                    onTap: () => _uploader.pickImage('logo'),
                    child: Obx(() {
                      final busy = _uploader.isLoading.value;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          AppNetworkAvatar(
                            imageUrl: _uploader.logoUrl,
                            radius: 48.r,
                            backgroundColor: kOffWhite,
                            fallbackAsset: const AssetImage(
                                'assets/smiling-redhaired-boy-illustration.png'),
                          ),
                          if (busy)
                            SizedBox(
                              width: 36.w,
                              height: 36.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(kPrimary),
                              ),
                            ),
                          if (!busy)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(5.r),
                                decoration: const BoxDecoration(
                                  color: kPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.camera_alt_outlined,
                                    color: kLightWhite, size: 14.spMin),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: 6.h),
                Center(
                  child: ReuseableText(
                    text: 'Tap to change photo',
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w400,
                    textColor: kGray,
                  ),
                ),
                SizedBox(height: 20.h),

                _label('Username'),
                CustomTextFormField(
                  hintText: 'Your name',
                  controller: _username,
                  prefixIcon:
                      const Icon(Icons.person_outline, color: kGray),
                ),
                SizedBox(height: 14.h),

                _label('Phone'),
                CustomTextFormField(
                  hintText: '+92 300 1234567',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon:
                      const Icon(Icons.phone_outlined, color: kGray),
                ),
                SizedBox(height: 14.h),

                _label('Email (read-only)'),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(color: kOffWhite),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined,
                          color: kGray, size: 18.spMin),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ReuseableText(
                          text: _user!.email,
                          fontSize: 13.spMin,
                          fontWeight: FontWeight.w500,
                          textColor: kGray,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                Obx(() {
                  final busy = _edit.isSaving;
                  return AbsorbPointer(
                    absorbing: busy,
                    child: CustomButton(
                      onTap: _submit,
                      btnHeight: 46.h,
                      radius: 10.r,
                      btnColor: busy ? kSecondary : kPrimary,
                      text: busy ? 'Saving…' : 'Save Changes',
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
        child: ReuseableText(
          text: text,
          fontSize: 12.spMin,
          fontWeight: FontWeight.w600,
          textColor: kDark,
        ),
      );
}
