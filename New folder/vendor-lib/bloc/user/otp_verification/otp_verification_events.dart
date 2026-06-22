import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update OTP input
class OtpChangedEvent extends OtpVerificationEvent {
  final String otp;

  const OtpChangedEvent(this.otp);

  @override
  List<Object> get props => [otp];
}

/// Event to verify OTP (email or phone)
class VerifyOtpEvent extends OtpVerificationEvent {}

/// Event to resend OTP (handles both email and phone)
class ResendOtpEvent extends OtpVerificationEvent {}

/// Event to send phone OTP via Twilio (called on screen init for phone verification)
class SendPhoneOtpEvent extends OtpVerificationEvent {
  final String phoneNumber;

  const SendPhoneOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

/// Event to start the resend timer countdown
class StartResendTimerEvent extends OtpVerificationEvent {}

/// Event triggered each second during countdown
class TickResendTimerEvent extends OtpVerificationEvent {}

/// Event to reset the OTP verification state
class ResetOtpStateEvent extends OtpVerificationEvent {}
