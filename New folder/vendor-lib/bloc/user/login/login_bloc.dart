import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/api_reospes.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../data/exceptions/app_exception.dart';
import '../../../repo/user/auth/auth_repo.dart';
import '../../../di/service_locator.dart';
import '../../../services/background/background_data_service.dart';
import '../../../services/session/session_manger.dart';
import '../../../services/socket/socket_service.dart';
import '../../../utils/enums.dart';
import 'login_events.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState.initial()) {
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ToggleRememberMeEvent>(_onToggleRememberMe);
    on<UserTypeChangedEvent>(_onUserTypeChanged);
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<ResetLoginStateEvent>(_onResetState);
  }

  void _onEmailChanged(EmailChangedEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      email: event.email,
      loginResponse: ApiResponse.initial(),
    ));
  }

  void _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      loginResponse: ApiResponse.initial(),
    ));
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onToggleRememberMe(
    ToggleRememberMeEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      rememberMe: !state.rememberMe,
      loginResponse: ApiResponse.initial(),
    ));
  }

  void _onUserTypeChanged(
    UserTypeChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    final userType = switch (event.userTypeIndex) {
      0 => UserType.user,
      1 => UserType.vendor,
      2 => UserType.driver,
      _ => UserType.user,
    };
    emit(state.copyWith(userType: userType));
  }

  // Future<void> _onLoginSubmit(
  //   LoginSubmitEvent event,
  //   Emitter<LoginState> emit,
  // ) async {
  //   // Validate email
  //   if (state.email.isEmpty) {
  //     emit(
  //       state.copyWith(
  //         loginResponse: ApiResponse.error("Please enter your email"),
  //       ),
  //     );
  //     return;
  //   }

  //   // Basic email validation
  //   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //   if (!emailRegex.hasMatch(state.email)) {
  //     emit(
  //       state.copyWith(
  //         loginResponse: ApiResponse.error("Please enter a valid email"),
  //       ),
  //     );
  //     return;
  //   }

  //   // Validate password
  //   if (state.password.isEmpty) {
  //     emit(
  //       state.copyWith(
  //         loginResponse: ApiResponse.error("Please enter your password"),
  //       ),
  //     );
  //     return;
  //   }

  //   emit(state.copyWith(loginResponse: ApiResponse.loading()));

  //   final data = {
  //     "email": state.email,
  //     "password": state.password,
  //     "userType": state.userType == UserType.user ? "user" : "vendor",
  //   };

  //   await _authRepo
  //       .login(data)
  //       .then((user) async {
  //         if (user.userToken != null && user.userToken!.isNotEmpty) {
  //           // Save user session
  //           await SessionManager().saveUser(user);
  //           emit(state.copyWith(loginResponse: ApiResponse.success(user)));
  //         } else {
  //           emit(
  //             state.copyWith(
  //               loginResponse: ApiResponse.error("Invalid email or password"),
  //             ),
  //           );
  //         }
  //       })
  //       .onError((error, stackTrace) {
  //         emit(
  //           state.copyWith(loginResponse: ApiResponse.error(error.toString())),
  //         );
  //       });
  // }

  Future<void> _onLoginSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    // Clear previous response
    emit(state.copyWith(loginResponse: ApiResponse.initial()));

    // Client-side validation
    if (state.email.trim().isEmpty) {
      emit(
        state.copyWith(
          loginResponse: ApiResponse.error("Please enter your email"),
        ),
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(state.email.trim())) {
      emit(
        state.copyWith(
          loginResponse: ApiResponse.error("Please enter a valid email"),
        ),
      );
      return;
    }

    if (state.password.isEmpty) {
      emit(
        state.copyWith(
          loginResponse: ApiResponse.error("Please enter your password"),
        ),
      );
      return;
    }

    emit(state.copyWith(loginResponse: ApiResponse.loading()));

    try {
      final data = {
        "email": state.email.trim(),
        "password": state.password,
      };

      final user = await authRepo.login(data);

      if (user.userToken != null && user.userToken!.isNotEmpty) {
        await SessionManager().saveUser(user);
        getIt<SocketService>().init(user.userToken!, userId: user.id);

        // Load addresses, profile, and settings in the background
        unawaited(BackgroundDataService().loadAllBackgroundData());

        emit(
          state.copyWith(
            loginResponse: ApiResponse.success(
              user,
              message: "Login successful",
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            loginResponse: ApiResponse.error(
              "Invalid credentials – no token received",
            ),
          ),
        );
      }
    } on ApiErrorResponse catch (e) {
      // ← This catches {"status":false, "message":"User not found"}
      emit(state.copyWith(loginResponse: ApiResponse.error(e.message)));
    } on BadRequestException catch (e) {
      // Fallback for 400 when not ApiErrorResponse
      String msg = e.toString().replaceFirst(RegExp(r'^[^:]+: '), '').trim();
      if (msg.startsWith('{')) msg = "Invalid request";
      emit(state.copyWith(loginResponse: ApiResponse.error(msg)));
    } on NoInternetException {
      emit(
        state.copyWith(
          loginResponse: ApiResponse.error("No internet connection"),
        ),
      );
    } on RequestTimeOutException {
      emit(
        state.copyWith(loginResponse: ApiResponse.error("Request timed out")),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loginResponse: ApiResponse.error("Unexpected error: ${e.toString()}"),
        ),
      );
    }
  }

  void _onResetState(ResetLoginStateEvent event, Emitter<LoginState> emit) {
    emit(LoginState.initial());
  }
}
