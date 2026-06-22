import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChangedEvent extends ForgotPasswordEvent {
  final String email;

  const EmailChangedEvent(this.email);

  @override
  List<Object> get props => [email];
}

class SubmitForgotPasswordEvent extends ForgotPasswordEvent {}

class ResetStateEvent extends ForgotPasswordEvent {}
