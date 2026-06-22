import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/storage/local_storage.dart';
import '../../../services/session/session_manger.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static const String _themeKey = 'theme_mode';
  final LocalStorage _localStorage = LocalStorage();

  ProfileBloc() : super(const ProfileState()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final themeValue = await _localStorage.getValue(_themeKey);

    ThemeMode themeMode;
    if (themeValue == null) {
      // First time - default to system
      themeMode = ThemeMode.system;
    } else {
      final themeIndex = int.tryParse(themeValue) ?? 0;
      themeMode = ThemeMode.values[themeIndex];
    }

    emit(state.copyWith(themeMode: themeMode, isLoading: false));
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    _localStorage.setValue(_themeKey, event.themeMode.index.toString());
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final session = SessionManager();
    await session.loadSettings();
    
    emit(state.copyWith(
      rtl: session.rtl,
      language: session.language,
      isLoading: false,
    ));
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      rtl: event.rtl,
      language: event.language,
    ));
  }
}
