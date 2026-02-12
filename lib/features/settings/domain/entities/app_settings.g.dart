// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$AppSettingsImpl(
  themeMode: json['themeMode'] == null
      ? ThemeMode.system
      : const ThemeModeConverter().fromJson(json['themeMode'] as String),
  autoLockTimeoutSeconds:
      (json['autoLockTimeoutSeconds'] as num?)?.toInt() ?? 300,
  clipboardClearSeconds: (json['clipboardClearSeconds'] as num?)?.toInt() ?? 30,
  biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
  showPasswordStrength: json['showPasswordStrength'] as bool? ?? true,
  breachCheckEnabled: json['breachCheckEnabled'] as bool? ?? true,
  defaultPasswordLength: (json['defaultPasswordLength'] as num?)?.toInt() ?? 16,
  includeUppercase: json['includeUppercase'] as bool? ?? true,
  includeLowercase: json['includeLowercase'] as bool? ?? true,
  includeDigits: json['includeDigits'] as bool? ?? true,
  includeSymbols: json['includeSymbols'] as bool? ?? true,
  excludedCharacters: json['excludedCharacters'] as String? ?? '',
  lastBackupDate: json['lastBackupDate'] == null
      ? null
      : DateTime.parse(json['lastBackupDate'] as String),
);

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'autoLockTimeoutSeconds': instance.autoLockTimeoutSeconds,
      'clipboardClearSeconds': instance.clipboardClearSeconds,
      'biometricsEnabled': instance.biometricsEnabled,
      'showPasswordStrength': instance.showPasswordStrength,
      'breachCheckEnabled': instance.breachCheckEnabled,
      'defaultPasswordLength': instance.defaultPasswordLength,
      'includeUppercase': instance.includeUppercase,
      'includeLowercase': instance.includeLowercase,
      'includeDigits': instance.includeDigits,
      'includeSymbols': instance.includeSymbols,
      'excludedCharacters': instance.excludedCharacters,
      'lastBackupDate': instance.lastBackupDate?.toIso8601String(),
    };
