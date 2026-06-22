import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadThemeEvent extends ProfileEvent {}

class LoadSettingsEvent extends ProfileEvent {}

class ChangeThemeEvent extends ProfileEvent {
  final ThemeMode themeMode;

  ChangeThemeEvent({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

class ChangeLocaleEvent extends ProfileEvent {
  final String language;
  final bool rtl;

  ChangeLocaleEvent({required this.language, required this.rtl});

  @override
  List<Object?> get props => [language, rtl];
}
