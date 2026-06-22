import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class CurrentPasswordChangedEvent extends ChangePasswordEvent {
  final String currentPassword;

  const CurrentPasswordChangedEvent(this.currentPassword);

  @override
  List<Object> get props => [currentPassword];
}

class NewPasswordChangedEvent extends ChangePasswordEvent {
  final String newPassword;

  const NewPasswordChangedEvent(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}

class ConfirmPasswordChangedEvent extends ChangePasswordEvent {
  final String confirmPassword;

  const ConfirmPasswordChangedEvent(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class ToggleCurrentPasswordVisibilityEvent extends ChangePasswordEvent {}

class ToggleNewPasswordVisibilityEvent extends ChangePasswordEvent {}

class ToggleConfirmPasswordVisibilityEvent extends ChangePasswordEvent {}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final String token;

  const SubmitChangePasswordEvent(this.token);

  @override
  List<Object> get props => [token];
}

class ResetChangePasswordStateEvent extends ChangePasswordEvent {}
