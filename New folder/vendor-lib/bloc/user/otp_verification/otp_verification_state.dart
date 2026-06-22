import 'package:equatable/equatable.dart';
import '../../../data/api/api_reospes.dart';

enum VerificationType { email, phone }

class OtpVerificationState extends Equatable {
  final String otp;
  final String? phoneNumber;
  final String? email;
  final VerificationType verificationType;
  final int resendSeconds;
  final bool canResend;
  final bool isVerified;
  final ApiResponse<Map<String, dynamic>> verificationResponse;

  const OtpVerificationState({
    this.otp = "",
    this.phoneNumber,
    this.email,
    this.verificationType = VerificationType.email,
    this.resendSeconds = 60,
    this.canResend = false,
    this.isVerified = false,
    required this.verificationResponse,
  });

  factory OtpVerificationState.initial({
    String? phoneNumber,
    String? email,
    VerificationType? verificationType,
  }) {
    return OtpVerificationState(
      phoneNumber: phoneNumber,
      email: email,
      verificationType: verificationType ?? VerificationType.email,
      verificationResponse: ApiResponse.initial(),
    );
  }

  OtpVerificationState copyWith({
    String? otp,
    String? phoneNumber,
    String? email,
    VerificationType? verificationType,
    int? resendSeconds,
    bool? canResend,
    bool? isVerified,
    ApiResponse<Map<String, dynamic>>? verificationResponse,
  }) {
    return OtpVerificationState(
      otp: otp ?? this.otp,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      verificationType: verificationType ?? this.verificationType,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      canResend: canResend ?? this.canResend,
      isVerified: isVerified ?? this.isVerified,
      verificationResponse: verificationResponse ?? this.verificationResponse,
    );
  }

  String get contactInfo {
    if (verificationType == VerificationType.phone && phoneNumber != null) {
      return phoneNumber!;
    } else if (verificationType == VerificationType.email && email != null) {
      return email!;
    }
    return 'Unknown';
  }

  @override
  List<Object?> get props => [
        otp,
        phoneNumber,
        email,
        verificationType,
        resendSeconds,
        canResend,
        isVerified,
        verificationResponse,
      ];
}
