import 'package:flutter/material.dart';

import '../../../../../config/config.dart';
import '../../../../../config/widgets/app_btn.dart';
import '../../../../../routes/route_name.dart';

Widget buildContinueButton(BuildContext context) {
  return AppButton(
    backgroundColor: AppColors.success,
    text: 'Continue',
    onPressed: () {
      // Navigate back to profile or home
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.mainScreen,
        (route) => false,
      );
    },
  );
}
