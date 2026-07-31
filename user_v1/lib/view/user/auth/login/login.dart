import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../models/login/login_model.dart';
import '../../../../view_models/controller/login/login_view_model.dart';
import '../widgets/email_text_form_field.dart';
import '../widgets/password_text_field.dart';
import '../../../../res/res_imports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
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
                  topRight: Radius.circular(30.r)),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  // ! animation
                  Lottie.asset('assets/ani2.json'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        // ! email
                        EmailTextFormField(
                          controller: _emailController,
                          hintText: 'Enter Email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: 22.spMin,
                            color: kGray,
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        // ! password
                        PasswordFormField(
                          controller: _passwordController,
                          hintText: 'Enter Password',
                          prefixIcon: Icon(
                            Icons.password_outlined,
                            size: 22.spMin,
                            color: kGray,
                          ),
                        ),
                        // ! Register button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteName.RegisterScreen);
                                  },
                                  child: ReuseableText(
                                    text: 'Register',
                                    fontSize: 14.spMin,
                                    textColor: Colors.blue,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        // ! login  button
                        CustomButton(
                          onTap: () {
                            // Get.toNamed(RouteName.mainScreen);
                            if (_emailController.text.isNotEmpty &&
                                _passwordController.text.length >= 8) {
                              LoginModel model = LoginModel(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              var data = loginModelToJson(model);

                              controller.loginFunction(data);
                            }
                          },
                          btnHeight: 40.h,
                          btnWidth: width,
                          radius: 9.r,
                          child: const Center(
                              child: ReuseableText(
                            text: 'L O G I N',
                            textColor: Colors.white,
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
