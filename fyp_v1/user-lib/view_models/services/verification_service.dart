// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../varification/phone_varification_view_model.dart';

// class VerificationService {
//   final controller = Get.put(PhoneVarificationController());
//   final FirebaseAuth _auth = FirebaseAuth.instance;
// // ! phone number verify
//   Future<void> verifyPhoneNumber(String phoneNumber,
//       {required Null Function(String verificationId, int? resendToken)
//           codeSend}) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (phoneAuthCredential) {
//         controller.verifyPhone();
//       },
//       verificationFailed: (FirebaseAuthException e) => debugPrint(e.toString()),
//       codeSent: (verificationId, resendingToken) {
//         codeSend(verificationId, resendingToken);
//       },
//       codeAutoRetrievalTimeout: (verificationId) {},
//     );
//   }

// // ! sms code verify
//   Future<void> verifySmsCode(String verificationId, String smsCode) async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId, smsCode: smsCode);

//     await _auth.signInWithCredential(credential).then(
//       (value) {
//         controller.verifyPhone();
//       },
//     );
//   }
// }
