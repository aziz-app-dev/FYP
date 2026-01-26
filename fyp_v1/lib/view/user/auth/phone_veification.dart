import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../view_models/varification/phone_varification_view_model.dart';
import 'widgets/email_text_form_field.dart';
import '../../../../res/res_imports.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({super.key});

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  // VerificationService _verificationServices = VerificationService();
  // String _verificationId = '';
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhoneVarificationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimary,
        title: const ReuseableText(
          text: 'Verify Your Phone',
          fontSize: 16,
          textColor: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EmailTextFormField(
                  controller: phoneController,
                  hintText: 'Enter your Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(
                  height: 35.h,
                ),
                CustomButton(
                  btnColor: kPrimary,
                  btnHeight: 40,
                  btnWidth: width,
                  onTap: () {
                    controller.verifyPhone2(phoneController.text);
                  },
                  child: const Center(
                      child: ReuseableText(
                    text: 'Verify',
                    fontSize: 16,
                    textColor: Colors.white,
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
