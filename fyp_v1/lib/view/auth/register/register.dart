import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../models/resgistration/reegistration_model.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/components/background_container.dart';
import '../../../res/components/coustom_button.dart';
import '../../../res/components/reuseable_text.dart';
import '../../../res/routes/routes_name.dart';
import '../../../view_models/controller/resistration/registration_view_model.dart';
import '../widgets/email_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _userNameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    return Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          title: const ReuseableText(
            text: 'Register',
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
                  SizedBox(
                      width: width,
                      height: 250.h,
                      child: Lottie.asset('assets/ani2.json')),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        EmailTextFormField(
                          controller: _userNameController,
                          hintText: 'Enter UserName',
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            size: 22.spMin,
                            color: kGray,
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
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
                        EmailTextFormField(
                          controller: _passwordController,
                          hintText: 'Enter Password',
                          prefixIcon: Icon(
                            Icons.password_outlined,
                            size: 22.spMin,
                            color: kGray,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteName.LoginScreen);
                                  },
                                  child: ReuseableText(
                                    text: 'All ready registered',
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
                        CustomButton(
                          onTap: () {
                            if (_emailController.text.isNotEmpty &&
                                _userNameController.text.isNotEmpty &&
                                _passwordController.text.length >= 8) {
                              RegistrationModel model = RegistrationModel(
                                  username: _userNameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              var data = registrationModelToJson(model);

                              controller.registrationFunction(data);
                            }
                          },
                          btnHeight: 40.h,
                          btnWidth: width,
                          radius: 9.r,
                          child: const Center(
                              child: ReuseableText(
                            text: 'R E G I S T E R',
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
