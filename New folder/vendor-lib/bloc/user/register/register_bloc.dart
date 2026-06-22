import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/api_reospes.dart';
import '../../../repo/user/auth/auth_repo.dart';
import '../../../repo/driver/driver_repo.dart';
import '../../../di/service_locator.dart';
import '../../../utils/enums.dart';
import 'register_events.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepo _authRepo;

  RegisterBloc({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(RegisterState.initial()) {
    on<UsernameChangedEvent>(_onUsernameChanged);
    on<EmailChangedEvent>(_onEmailChanged);
    on<PhoneChangedEvent>(_onPhoneChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ConfirmPasswordChangedEvent>(_onConfirmPasswordChanged);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibilityEvent>(
      _onToggleConfirmPasswordVisibility,
    );
    on<RegisterSubmitEvent>(_onRegisterSubmit);
    on<ResetRegisterStateEvent>(_onResetState);
    on<ToggleTermsAcceptedEvent>(_onToggleTerms);
    on<TogglePrivacyPolicyAcceptedEvent>(_onTogglePrivacy);
    on<UserTypeEvent>(_onUserTypeChage);
  }

  void _onUsernameChanged(
    UsernameChangedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        username: event.username,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onEmailChanged(EmailChangedEvent event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onPhoneChanged(PhoneChangedEvent event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        phone: event.phone,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChangedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibilityEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onToggleTerms(
    ToggleTermsAcceptedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        termsAccepted: !state.termsAccepted,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onTogglePrivacy(
    TogglePrivacyPolicyAcceptedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        privacyPolicyAccepted: !state.privacyPolicyAccepted,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  void _onUserTypeChage(UserTypeEvent event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        userType: event.userType,
        registerResponse: ApiResponse.initial(),
      ),
    );
  }

  Future<void> _onRegisterSubmit(
    RegisterSubmitEvent event,
    Emitter<RegisterState> emit,
  ) async {
    // Reset previous response
    emit(state.copyWith(registerResponse: ApiResponse.initial()));

    // Client-side validation
    if (!state.termsAccepted) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error(
            'Please accept the Terms of Service',
          ),
        ),
      );
      return;
    }
    if (!state.privacyPolicyAccepted) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error(
            'Please accept the Privacy Policy',
          ),
        ),
      );
      return;
    }

    final username = state.username.trim();
    if (username.isEmpty) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error("Please enter your username"),
        ),
      );
      return;
    }
    if (username.length < 3) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error(
            "Username must be at least 3 characters",
          ),
        ),
      );
      return;
    }

    final email = state.email.trim();
    if (email.isEmpty) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error("Please enter your email"),
        ),
      );
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error("Please enter a valid email"),
        ),
      );
      return;
    }

    final password = state.password;
    if (password.isEmpty) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error("Please enter your password"),
        ),
      );
      return;
    }
    if (password.length < 8) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error(
            "Password must be at least 8 characters",
          ),
        ),
      );
      return;
    }

    final confirmPassword = state.confirmPassword;
    if (confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error("Please confirm your password"),
        ),
      );
      return;
    }
    if (password != confirmPassword) {
      emit(
        state.copyWith(
          registerResponse: ApiResponse.error("Passwords do not match"),
        ),
      );
      return;
    }

    // Start loading
    emit(state.copyWith(registerResponse: ApiResponse.loading()));

    try {
      if (state.userType == UserType.driver) {
        final phone = state.phone.trim();
        if (phone.isEmpty) {
          emit(
            state.copyWith(
              registerResponse: ApiResponse.error("Please enter phone number"),
            ),
          );
          return;
        }

        await getIt<DriverRepo>().register(
          name: username,
          email: email,
          phone: phone,
          password: password,
        );

        emit(
          state.copyWith(
            registerResponse: ApiResponse.success(
              "Driver registered successfully. Please login.",
            ),
          ),
        );
        return;
      }

      final data = {
        "username": username,
        "email": email,
        "password": password,
        "termsAccepted": state.termsAccepted,
        "privacyPolicyAccepted": state.privacyPolicyAccepted,
      };
      final response = await _authRepo.register(data);
      emit(
        state.copyWith(registerResponse: ApiResponse.success(response.message)),
      );
    } catch (error) {
      emit(
        state.copyWith(registerResponse: ApiResponse.error(error.toString())),
      );
    }

    // Optional: reset form / navigate → do it in UI listener
  }
}

void _onResetState(ResetRegisterStateEvent event, Emitter<RegisterState> emit) {
  emit(RegisterState.initial());
}
