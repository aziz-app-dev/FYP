import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/api_reospes.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../data/exceptions/app_exception.dart';
import '../../../repo/user/auth/verification_repo.dart';
import '../../../services/background/background_data_service.dart';
import '../../../services/session/session_manger.dart';
import 'otp_verification_events.dart';
import 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final VerificationRepo verificationRepo;
  final SessionManager sessionManager;
  Timer? _resendTimer;

  OtpVerificationBloc({
    required this.verificationRepo,
    required this.sessionManager,
    String? phoneNumber,
    String? email,
    VerificationType? verificationType,
  }) : super(
         OtpVerificationState.initial(
           phoneNumber: phoneNumber,
           email: email,
           verificationType: verificationType,
         ),
       ) {
    on<OtpChangedEvent>(_onOtpChanged);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<SendPhoneOtpEvent>(_onSendPhoneOtp);
    on<StartResendTimerEvent>(_onStartResendTimer);
    on<TickResendTimerEvent>(_onTickResendTimer);
    on<ResetOtpStateEvent>(_onResetState);

    // For phone verification, send OTP automatically when bloc is created
    if (verificationType == VerificationType.phone && phoneNumber != null) {
      add(SendPhoneOtpEvent(phoneNumber));
    } else {
      // For email verification, just start the timer (OTP already sent during registration)
      add(StartResendTimerEvent());
    }
  }

  void _onOtpChanged(
    OtpChangedEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(state.copyWith(otp: event.otp));
  }

  /// Send phone OTP via Twilio
  Future<void> _onSendPhoneOtp(
    SendPhoneOtpEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(state.copyWith(
      verificationResponse: ApiResponse.loading(),
      phoneNumber: event.phoneNumber,
    ));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(
            verificationResponse: ApiResponse.error("Authentication required"),
          ),
        );
        return;
      }

      final response = await verificationRepo.sendPhoneOtp(
        event.phoneNumber,
        token,
      );

      emit(
        state.copyWith(
          verificationResponse: ApiResponse.success(
            response,
            message: "OTP sent to ${event.phoneNumber}",
          ),
        ),
      );

      // Start resend timer after successful OTP send
      add(StartResendTimerEvent());
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(verificationResponse: ApiResponse.error(e.message)));
    } on UnauthorizedException catch (e) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            e.toString().split(':').last.trim(),
          ),
        ),
      );
    } on NoInternetException {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error("No internet connection"),
        ),
      );
    } on RequestTimeOutException {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error("Request timed out"),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            "Failed to send OTP: ${e.toString()}",
          ),
        ),
      );
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    // Validation
    if (state.otp.isEmpty || state.otp.length != 6) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            "Please enter complete 6-digit code",
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(verificationResponse: ApiResponse.loading()));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(
            verificationResponse: ApiResponse.error("Authentication required"),
          ),
        );
        return;
      }

      Map<String, dynamic> response;

      if (state.verificationType == VerificationType.email) {
        // Email verification with OTP
        final email = state.email ?? '';
        response = await verificationRepo.verifyEmail(state.otp, email, token);
      } else {
        // Phone verification with OTP via Twilio
        final phone = state.phoneNumber ?? '';
        response = await verificationRepo.verifyPhoneOtp(phone, state.otp, token);
      }

      // Fetch updated user data from backend after successful verification
      final updatedUser = await verificationRepo.getCurrentUser(token);

      // Save updated user data to session (this will update verification status)
      await sessionManager.saveUser(updatedUser);

      // Load addresses, profile, and settings in the background
      unawaited(BackgroundDataService().loadAllBackgroundData());

      emit(
        state.copyWith(
          isVerified: true,
          verificationResponse: ApiResponse.success(
            response,
            message: "Verification successful",
          ),
        ),
      );
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(verificationResponse: ApiResponse.error(e.message)));
    } on UnauthorizedException catch (e) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            e.toString().split(':').last.trim(),
          ),
        ),
      );
    } on NoInternetException {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error("No internet connection"),
        ),
      );
    } on RequestTimeOutException {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error("Request timed out"),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            "Verification failed: ${e.toString()}",
          ),
        ),
      );
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(state.copyWith(verificationResponse: ApiResponse.loading()));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(
            verificationResponse: ApiResponse.error("Authentication required"),
          ),
        );
        return;
      }

      Map<String, dynamic> response;

      if (state.verificationType == VerificationType.phone) {
        // Resend phone OTP via Twilio
        final phone = state.phoneNumber ?? '';
        response = await verificationRepo.resendPhoneOtp(phone, token);
      } else {
        // Resend email OTP
        final email = state.email ?? '';
        response = await verificationRepo.resendEmailOtp(email, token);
      }

      emit(
        state.copyWith(
          verificationResponse: ApiResponse.success(
            response,
            message: "OTP resent successfully",
          ),
        ),
      );

      // Restart the timer
      add(StartResendTimerEvent());
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(verificationResponse: ApiResponse.error(e.message)));
    } on UnauthorizedException catch (e) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            e.toString().split(':').last.trim(),
          ),
        ),
      );
    } on NoInternetException {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error("No internet connection"),
        ),
      );
    } on RequestTimeOutException {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error("Request timed out"),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          verificationResponse: ApiResponse.error(
            "Failed to resend OTP: ${e.toString()}",
          ),
        ),
      );
    }
  }

  void _onStartResendTimer(
    StartResendTimerEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    _resendTimer?.cancel();
    emit(state.copyWith(resendSeconds: 60, canResend: false));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickResendTimerEvent());
    });
  }

  void _onTickResendTimer(
    TickResendTimerEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    if (state.resendSeconds > 0) {
      emit(state.copyWith(resendSeconds: state.resendSeconds - 1));
    } else {
      emit(state.copyWith(canResend: true));
      _resendTimer?.cancel();
    }
  }

  void _onResetState(
    ResetOtpStateEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(
      OtpVerificationState.initial(
        phoneNumber: state.phoneNumber,
        email: state.email,
        verificationType: state.verificationType,
      ),
    );
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
