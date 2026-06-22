import '../../../const/app_url.dart';
import '../../../data/api/network_services_api.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../model/auth/api_response_model.dart';
import '../../../model/auth/user_model.dart';

class AuthRepo {
  final _api = NetworkServicesApi();

  /// Helper method to check for API errors
  void _checkForError(dynamic response) {
    if (response['status'] == false) {
      throw ApiErrorResponse.fromJson(response);
    }
  }

  /// Login user with email and password
  Future<UserModel> login(Map<String, dynamic> data) async {
    final response = await _api.postApi(AppUrl.loginUrl, data);
    _checkForError(response);
    return UserModel.fromJson(response["data"]);
  }

  /// Register new user
  Future<ApiResponse> register(Map<String, dynamic> data) async {
    final response = await _api.postApi(AppUrl.registerUrl, data);
    _checkForError(response);
    return ApiResponse.fromJson(response);
  }

  /// Verify OTP
  Future<ApiResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _api.postApi(
      AppUrl.verifyOtpUrl,
      {
        "email": email,
        "otp": otp,
      },
    );
    _checkForError(response);
    return ApiResponse.fromJson(response);
  }

  /// Resend OTP
  Future<ApiResponse> resendOtp({required String email}) async {
    final response = await _api.postApi(
      AppUrl.resendOtpUrl,
      {"email": email},
    );
    _checkForError(response);
    return ApiResponse.fromJson(response);
  }

  /// Forgot password - sends new password to email
  Future<ApiResponse> forgotPassword(String email) async {
    final response = await _api.postApi(
      AppUrl.forgotPasswordUrl,
      {"email": email},
    );
    _checkForError(response);
    return ApiResponse.fromJson(response);
  }

  /// Change password - requires authentication token
  Future<ApiResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    final response = await _api.postApiWithAuth(
      AppUrl.changePasswordUrl,
      {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      },
      token,
    );
    _checkForError(response);
    return ApiResponse.fromJson(response);
  }
}
