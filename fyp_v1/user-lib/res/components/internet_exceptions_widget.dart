// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:htv_2/res/components/coustom_button.dart';
// import 'package:htv_2/res/components/reuseable_text.dart';
// import 'package:htv_2/res/routes/routes_name.dart';

// import '../colors/app_color.dart';

// class InterNetExceptionWidget extends StatefulWidget {
//   const InterNetExceptionWidget({super.key});

//   @override
//   State<InterNetExceptionWidget> createState() =>
//       _InterNetExceptionWidgetState();
// }

// class _InterNetExceptionWidgetState extends State<InterNetExceptionWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 50.h,
//                 ),
//                 //  AssetImage('assets/1.jpg'),

//                 CircleAvatar(
//                   backgroundColor: kPrimary.withOpacity(.5),
//                   radius: 120.spMin,
//                   child: Image.asset(
//                     'assets/no-internet.png',
//                     // scale: 4.spMin,
//                     fit: BoxFit.contain,
//                     height: 150.h,
//                     width: 150.w,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 const ReuseableText(
//                   text: 'No internet',
//                   fontSize: 40,
//                   fontWeight: FontWeight.bold,
//                   textColor: kGray,
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 const ReuseableText(
//                   text: 'Please check your internet connectivity',
//                   fontSize: 25,
//                   fontWeight: FontWeight.w400,
//                   textColor: kGray,
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 CustomButton(
//                   onTap: () {
//                     Get.toNamed(RouteName.mainScreen);
//                   },
//                   btnHeight: 40.h,
//                   btnWidth: width,
//                   child: const Center(
//                     child: ReuseableText(
//                       text: 'R E T R Y',
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       textColor: Colors.white,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
