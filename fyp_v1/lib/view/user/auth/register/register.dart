import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/resgistration/reegistration_model.dart';
import '../../../../view_models/controller/resistration/registration_view_model.dart';
import '../widgets/email_text_form_field.dart';
import '../../../../res/res_imports.dart';

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

  // User type selection: 'Customer' or 'Vendor'
  String _selectedUserType = 'Customer';

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
                        SizedBox(
                          height: 25.h,
                        ),
                        // User Type Selector
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: kOffWhite,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReuseableText(
                                text: 'Register as:',
                                fontSize: 14.spMin,
                                fontWeight: FontWeight.w500,
                                textColor: kGray,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedUserType = 'Customer';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        decoration: BoxDecoration(
                                          color: _selectedUserType == 'Customer'
                                              ? kPrimary
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color:
                                                _selectedUserType == 'Customer'
                                                    ? kPrimary
                                                    : kGray,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_outline,
                                              size: 20.spMin,
                                              color:
                                                  _selectedUserType ==
                                                          'Customer'
                                                      ? Colors.white
                                                      : kGray,
                                            ),
                                            SizedBox(width: 6.w),
                                            ReuseableText(
                                              text: 'Customer',
                                              fontSize: 13.spMin,
                                              fontWeight: FontWeight.w500,
                                              textColor: _selectedUserType ==
                                                      'Customer'
                                                  ? Colors.white
                                                  : kGray,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedUserType = 'Vendor';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        decoration: BoxDecoration(
                                          color: _selectedUserType == 'Vendor'
                                              ? kPrimary
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: _selectedUserType == 'Vendor'
                                                ? kPrimary
                                                : kGray,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.store_outlined,
                                              size: 20.spMin,
                                              color:
                                                  _selectedUserType == 'Vendor'
                                                      ? Colors.white
                                                      : kGray,
                                            ),
                                            SizedBox(width: 6.w),
                                            ReuseableText(
                                              text: 'Vendor',
                                              fontSize: 13.spMin,
                                              fontWeight: FontWeight.w500,
                                              textColor:
                                                  _selectedUserType == 'Vendor'
                                                      ? Colors.white
                                                      : kGray,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                  password: _passwordController.text,
                                  userType: _selectedUserType);

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
