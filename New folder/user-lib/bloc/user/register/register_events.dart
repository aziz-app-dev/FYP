import 'package:equatable/equatable.dart';
import '../../../utils/enums.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class UsernameChangedEvent extends RegisterEvent {
  final String username;

  const UsernameChangedEvent(this.username);

  @override
  List<Object> get props => [username];
}

class EmailChangedEvent extends RegisterEvent {
  final String email;

  const EmailChangedEvent(this.email);

  @override
  List<Object> get props => [email];
}

class PhoneChangedEvent extends RegisterEvent {
  final String phone;

  const PhoneChangedEvent(this.phone);

  @override
  List<Object> get props => [phone];
}

class PasswordChangedEvent extends RegisterEvent {
  final String password;

  const PasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChangedEvent extends RegisterEvent {
  final String confirmPassword;

  const ConfirmPasswordChangedEvent(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class UserTypeEvent extends RegisterEvent {
  final UserType userType;

  const UserTypeEvent(this.userType);

  @override
  List<Object> get props => [userType];
}

class TogglePasswordVisibilityEvent extends RegisterEvent {}

class ToggleConfirmPasswordVisibilityEvent extends RegisterEvent {}

class ToggleTermsAcceptedEvent extends RegisterEvent {}

class TogglePrivacyPolicyAcceptedEvent extends RegisterEvent {}

class RegisterSubmitEvent extends RegisterEvent {}

class ResetRegisterStateEvent extends RegisterEvent {}
