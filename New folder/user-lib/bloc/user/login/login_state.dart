import 'package:equatable/equatable.dart';
import '../../../data/api/api_reospes.dart';
import '../../../model/auth/user_model.dart';
import '../../../utils/enums.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool rememberMe;
  final UserType userType;
  final ApiResponse<UserModel> loginResponse;

  const LoginState({
    this.email = "",
    this.password = "",
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.userType = UserType.user,
    required this.loginResponse,
  });

  factory LoginState.initial() {
    return LoginState(loginResponse: ApiResponse.initial());
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    UserType? userType,
    ApiResponse<UserModel>? loginResponse,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      userType: userType ?? this.userType,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isPasswordVisible,
    rememberMe,
    userType,
    loginResponse,
  ];
}
