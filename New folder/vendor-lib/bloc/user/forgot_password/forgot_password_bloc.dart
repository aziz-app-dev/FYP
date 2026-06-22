import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/api_reospes.dart';
import '../../../repo/user/auth/auth_repo.dart';
import 'forgot_password_events.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepo _authRepo;

  ForgotPasswordBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(ForgotPasswordState.initial()) {
    on<EmailChangedEvent>(_onEmailChanged);
    on<SubmitForgotPasswordEvent>(_onSubmitForgotPassword);
    on<ResetStateEvent>(_onResetState);
  }

  void _onEmailChanged(
    EmailChangedEvent event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      forgotPasswordResponse: ApiResponse.initial(),
    ));
  }

  Future<void> _onSubmitForgotPassword(
    SubmitForgotPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    // Validate email
    if (state.email.isEmpty) {
      emit(
        state.copyWith(
          forgotPasswordResponse: ApiResponse.error(
            "Please enter your email address",
          ),
        ),
      );
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(state.email)) {
      emit(
        state.copyWith(
          forgotPasswordResponse: ApiResponse.error(
            "Please enter a valid email address",
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(forgotPasswordResponse: ApiResponse.loading()));

    await _authRepo
        .forgotPassword(state.email)
        .then((response) {
          emit(
            state.copyWith(
              forgotPasswordResponse: ApiResponse.success(response.message),
            ),
          );
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              forgotPasswordResponse: ApiResponse.error(error.toString()),
            ),
          );
        });
  }

  void _onResetState(ResetStateEvent event, Emitter<ForgotPasswordState> emit) {
    emit(ForgotPasswordState.initial());
  }
}
