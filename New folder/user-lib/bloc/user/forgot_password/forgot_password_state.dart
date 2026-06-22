import 'package:equatable/equatable.dart';
import '../../../data/api/api_reospes.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final ApiResponse<String> forgotPasswordResponse;

  const ForgotPasswordState({
    this.email = "",
    required this.forgotPasswordResponse,
  });

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(forgotPasswordResponse: ApiResponse.initial());
  }

  ForgotPasswordState copyWith({
    String? email,
    ApiResponse<String>? forgotPasswordResponse,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      forgotPasswordResponse:
          forgotPasswordResponse ?? this.forgotPasswordResponse,
    );
  }

  @override
  List<Object?> get props => [email, forgotPasswordResponse];
}
