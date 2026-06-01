import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../common/res/colors/app_color.dart';
import '../../../common/res/components/background_container.dart';
import '../../../common/res/components/coustom_button.dart';
import '../../../common/res/components/reuseable_text.dart';
import '../../../common/utils/utils.dart';
import '../../../view models/controllers/login_view_model.dart';
import '../widgets/email_text_form_field.dart';
import '../widgets/password_text_field.dart';

/// Vendor Login — same layout as the user app's LoginScreen:
/// primary-colored AppBar, rounded-top white sheet, Lottie animation,
/// email + password fields, and a full-width login button.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Pre-filled dev credentials so you don't have to type every time.
  // Change these to match a seeded Vendor account in your database.
  late final TextEditingController _emailController =
      TextEditingController(text: 'vendor@test.com');
  late final TextEditingController _passwordController =
      TextEditingController(text: 'password123');
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(LoginController controller) {
    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      Utils.showWarning('Invalid email', 'Please enter a valid email');
      return;
    }
    if (_passwordController.text.length < 8) {
      Utils.showWarning(
          'Password too short', 'Password must be at least 8 characters.');
      return;
    }
    controller.login(
        _emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ReuseableText(
          text: 'Login',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textColor: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: kPrimary,
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 20.h),
              // Lottie animation (same asset used by user app)
              Lottie.asset('assets/ani2.json'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    EmailTextFormField(
                      controller: _emailController,
                      hintText: 'Enter Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 22.spMin,
                        color: kGray,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    PasswordFormField(
                      controller: _passwordController,
                      hintText: 'Enter Password',
                      prefixIcon: Icon(
                        Icons.password_outlined,
                        size: 22.spMin,
                        color: kGray,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Obx(() {
                      final busy = controller.isLoading;
                      return AbsorbPointer(
                        absorbing: busy,
                        child: CustomButton(
                          btnHeight: 44.h,
                          btnWidth: width,
                          radius: 9.r,
                          btnColor: busy ? kSecondary : kPrimary,
                          onTap: () => _submit(controller),
                          text: busy ? 'Signing in…' : 'L O G I N',
                        ),
                      );
                    }),
                    SizedBox(height: 14.h),
                    ReuseableText(
                      text:
                          'Only Vendor / Admin accounts can sign in here.',
                      fontSize: 11.spMin,
                      fontWeight: FontWeight.w400,
                      textColor: kGray,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
