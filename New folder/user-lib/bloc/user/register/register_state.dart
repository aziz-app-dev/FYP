import 'package:equatable/equatable.dart';
import '../../../data/api/api_reospes.dart';
import '../../../utils/enums.dart';

class RegisterState extends Equatable {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool termsAccepted;
  final bool privacyPolicyAccepted;
  final UserType userType;
  final ApiResponse<String> registerResponse;

  const RegisterState({
    this.username = "",
    this.email = "",
    this.phone = "",
    this.password = "",
    this.confirmPassword = "",
    this.isPasswordVisible = false,
    this.termsAccepted = false,
    this.privacyPolicyAccepted = false,
    this.userType = UserType.user,
    this.isConfirmPasswordVisible = false,
    required this.registerResponse,
  });

  factory RegisterState.initial() {
    return RegisterState(registerResponse: ApiResponse.initial());
  }

  RegisterState copyWith({
    String? username,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? termsAccepted,
    bool? privacyPolicyAccepted,
    UserType? userType,
    ApiResponse<String>? registerResponse,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      registerResponse: registerResponse ?? this.registerResponse,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      privacyPolicyAccepted: privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [
    username,
    email,
    phone,
    password,
    confirmPassword,
    isPasswordVisible,
    isConfirmPasswordVisible,
    registerResponse,
    termsAccepted,
    privacyPolicyAccepted,
    userType,
  ];
}
