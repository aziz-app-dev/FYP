import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProfileState extends Equatable {
  final ThemeMode themeMode;
  final bool rtl;
  final String language;
  final bool isLoading;

  const ProfileState({
    this.themeMode = ThemeMode.system,
    this.rtl = false,
    this.language = 'en',
    this.isLoading = true,
  });

  ProfileState copyWith({
    ThemeMode? themeMode,
    bool? rtl,
    String? language,
    bool? isLoading,
  }) {
    return ProfileState(
      themeMode: themeMode ?? this.themeMode,
      rtl: rtl ?? this.rtl,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [themeMode, rtl, language, isLoading];
}
