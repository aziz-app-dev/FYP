import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../model/auth/user_model.dart';

class VerificationRepo {
  final api = NetworkServicesApi();

  // ============= Email Verification =============

  /// Verify email with OTP
  /// Endpoint: POST /api/auth/verify-otp
  Future<Map<String, dynamic>> verifyEmail(String otp, String email, String token) async {
    final response = await api.postApiWithAuth(
      AppUrl.verifyOtpUrl,
      {'otp': otp, 'email': email},
      token,
    );
    return response as Map<String, dynamic>;
  }

  /// Resend email OTP
  /// Endpoint: POST /api/auth/resend-otp
  Future<Map<String, dynamic>> resendEmailOtp(String email, String token) async {
    final response = await api.postApiWithAuth(
      AppUrl.resendOtpUrl,
      {'email': email},
      token,
    );
    return response as Map<String, dynamic>;
  }

  // ============= Phone Verification (Twilio) =============

  /// Send phone OTP via Twilio
  /// Endpoint: POST /api/auth/send-phone-otp
  Future<Map<String, dynamic>> sendPhoneOtp(String phoneNumber, String token) async {
    final response = await api.postApiWithAuth(
      AppUrl.sendPhoneOtpUrl,
      {'phoneNumber': phoneNumber},
      token,
    );
    return response as Map<String, dynamic>;
  }

  /// Verify phone OTP via Twilio
  /// Endpoint: POST /api/auth/verify-phone-otp
  Future<Map<String, dynamic>> verifyPhoneOtp(String phoneNumber, String otp, String token) async {
    final response = await api.postApiWithAuth(
      AppUrl.verifyPhoneOtpUrl,
      {'phoneNumber': phoneNumber, 'otp': otp},
      token,
    );
    return response as Map<String, dynamic>;
  }

  /// Resend phone OTP via Twilio
  /// Endpoint: POST /api/auth/resend-phone-otp
  Future<Map<String, dynamic>> resendPhoneOtp(String phoneNumber, String token) async {
    final response = await api.postApiWithAuth(
      AppUrl.resendPhoneOtpUrl,
      {'phoneNumber': phoneNumber},
      token,
    );
    return response as Map<String, dynamic>;
  }

  /// Update phone number
  /// Endpoint: PUT /api/auth/update-phone
  Future<Map<String, dynamic>> updatePhone(String phoneNumber, String token) async {
    final response = await api.putApiWithAuth(
      AppUrl.updatePhoneUrl,
      {'phoneNumber': phoneNumber},
      token,
    );
    return response as Map<String, dynamic>;
  }

  /// Check SMS configuration status
  /// Endpoint: GET /api/auth/sms-config
  Future<Map<String, dynamic>> checkSmsConfig() async {
    final response = await api.getApi(AppUrl.smsConfigUrl);
    return response as Map<String, dynamic>;
  }

  // ============= User Data =============

  /// Get current user data
  /// Endpoint: GET /api/user
  Future<UserModel> getCurrentUser(String token) async {
    final response = await api.getApiWithAuth(AppUrl.userUrl, token);
    return UserModel.fromJson(response as Map<String, dynamic>);
  }
}
