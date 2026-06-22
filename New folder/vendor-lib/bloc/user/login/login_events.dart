import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChangedEvent extends LoginEvent {
  final String email;

  const EmailChangedEvent(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChangedEvent extends LoginEvent {
  final String password;

  const PasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class TogglePasswordVisibilityEvent extends LoginEvent {}

class ToggleRememberMeEvent extends LoginEvent {}

class UserTypeChangedEvent extends LoginEvent {
  final int userTypeIndex; // 0 = user, 1 = vendor, 2 = driver

  const UserTypeChangedEvent(this.userTypeIndex);

  @override
  List<Object> get props => [userTypeIndex];
}

class LoginSubmitEvent extends LoginEvent {}

class ResetLoginStateEvent extends LoginEvent {}
