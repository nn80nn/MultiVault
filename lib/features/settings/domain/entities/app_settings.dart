import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

class ThemeModeConverter implements JsonConverter<ThemeMode, String> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(String json) {
    switch (json) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  String toJson(ThemeMode object) => object.name;
}

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(300) int autoLockTimeoutSeconds,
    @Default(30) int clipboardClearSeconds,
    @Default(false) bool biometricsEnabled,
    @Default(true) bool showPasswordStrength,
    @Default(true) bool breachCheckEnabled,
    @Default(16) int defaultPasswordLength,
    @Default(true) bool includeUppercase,
    @Default(true) bool includeLowercase,
    @Default(true) bool includeDigits,
    @Default(true) bool includeSymbols,
    @Default('') String excludedCharacters,
    DateTime? lastBackupDate,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
