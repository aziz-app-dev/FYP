import 'package:equatable/equatable.dart';
import '../../../utils/enums.dart';

class ChangePasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String message;
  final Status apiStatus;
  final bool isSuccess;
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;

  const ChangePasswordState({
    this.currentPassword = "",
    this.newPassword = "",
    this.confirmPassword = "",
    this.message = "",
    this.apiStatus = Status.initial,
    this.isSuccess = false,
    this.isCurrentPasswordVisible = false,
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? message,
    Status? apiStatus,
    bool? isSuccess,
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus,
      isSuccess: isSuccess ?? this.isSuccess,
      isCurrentPasswordVisible:
          isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    message,
    apiStatus,
    isSuccess,
    isCurrentPasswordVisible,
    isNewPasswordVisible,
    isConfirmPasswordVisible,
  ];
}
