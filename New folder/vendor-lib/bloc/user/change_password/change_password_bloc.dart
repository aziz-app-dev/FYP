import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/user/auth/auth_repo.dart';
import '../../../utils/enums.dart';
import 'change_password_events.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthRepo _authRepo;

  ChangePasswordBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const ChangePasswordState()) {
    on<CurrentPasswordChangedEvent>(_onCurrentPasswordChanged);
    on<NewPasswordChangedEvent>(_onNewPasswordChanged);
    on<ConfirmPasswordChangedEvent>(_onConfirmPasswordChanged);
    on<ToggleCurrentPasswordVisibilityEvent>(
      _onToggleCurrentPasswordVisibility,
    );
    on<ToggleNewPasswordVisibilityEvent>(_onToggleNewPasswordVisibility);
    on<ToggleConfirmPasswordVisibilityEvent>(
      _onToggleConfirmPasswordVisibility,
    );
    on<SubmitChangePasswordEvent>(_onSubmitChangePassword);
    on<ResetChangePasswordStateEvent>(_onResetState);
  }

  void _onCurrentPasswordChanged(
    CurrentPasswordChangedEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      currentPassword: event.currentPassword,
      apiStatus: Status.initial,
      message: "",
    ));
  }

  void _onNewPasswordChanged(
    NewPasswordChangedEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      newPassword: event.newPassword,
      apiStatus: Status.initial,
      message: "",
    ));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChangedEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      apiStatus: Status.initial,
      message: "",
    ));
  }

  void _onToggleCurrentPasswordVisibility(
    ToggleCurrentPasswordVisibilityEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      isCurrentPasswordVisible: !state.isCurrentPasswordVisible,
      apiStatus: Status.initial,
      message: "",
    ));
  }

  void _onToggleNewPasswordVisibility(
    ToggleNewPasswordVisibilityEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      isNewPasswordVisible: !state.isNewPasswordVisible,
      apiStatus: Status.initial,
      message: "",
    ));
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibilityEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
      apiStatus: Status.initial,
      message: "",
    ));
  }

  Future<void> _onSubmitChangePassword(
    SubmitChangePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    // Validate current password
    if (state.currentPassword.isEmpty) {
      emit(
        state.copyWith(
          message: "Please enter your current password",
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
      return;
    }

    // Validate new password
    if (state.newPassword.isEmpty) {
      emit(
        state.copyWith(
          message: "Please enter a new password",
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
      return;
    }

    // Validate new password length
    if (state.newPassword.length < 6) {
      emit(
        state.copyWith(
          message: "New password must be at least 6 characters",
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
      return;
    }

    // Validate confirm password
    if (state.confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          message: "Please confirm your new password",
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
      return;
    }

    // Validate passwords match
    if (state.newPassword != state.confirmPassword) {
      emit(
        state.copyWith(
          message: "Passwords do not match",
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
      return;
    }

    // Validate new password is different from current
    if (state.currentPassword == state.newPassword) {
      emit(
        state.copyWith(
          message: "New password must be different from current password",
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
      return;
    }

    emit(state.copyWith(apiStatus: Status.loading));

    try {
      final response = await _authRepo.changePassword(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
        token: event.token,
      );

      if (response.status) {
        emit(
          state.copyWith(
            message: response.message,
            apiStatus: Status.success,
            isSuccess: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            message: response.message,
            apiStatus: Status.error,
            isSuccess: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          apiStatus: Status.error,
          isSuccess: false,
        ),
      );
    }
  }

  void _onResetState(
    ResetChangePasswordStateEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(const ChangePasswordState());
  }
}
