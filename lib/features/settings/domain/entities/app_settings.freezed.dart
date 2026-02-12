// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @ThemeModeConverter()
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  int get autoLockTimeoutSeconds => throw _privateConstructorUsedError;
  int get clipboardClearSeconds => throw _privateConstructorUsedError;
  bool get biometricsEnabled => throw _privateConstructorUsedError;
  bool get showPasswordStrength => throw _privateConstructorUsedError;
  bool get breachCheckEnabled => throw _privateConstructorUsedError;
  int get defaultPasswordLength => throw _privateConstructorUsedError;
  bool get includeUppercase => throw _privateConstructorUsedError;
  bool get includeLowercase => throw _privateConstructorUsedError;
  bool get includeDigits => throw _privateConstructorUsedError;
  bool get includeSymbols => throw _privateConstructorUsedError;
  String get excludedCharacters => throw _privateConstructorUsedError;
  DateTime? get lastBackupDate => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    @ThemeModeConverter() ThemeMode themeMode,
    int autoLockTimeoutSeconds,
    int clipboardClearSeconds,
    bool biometricsEnabled,
    bool showPasswordStrength,
    bool breachCheckEnabled,
    int defaultPasswordLength,
    bool includeUppercase,
    bool includeLowercase,
    bool includeDigits,
    bool includeSymbols,
    String excludedCharacters,
    DateTime? lastBackupDate,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? autoLockTimeoutSeconds = null,
    Object? clipboardClearSeconds = null,
    Object? biometricsEnabled = null,
    Object? showPasswordStrength = null,
    Object? breachCheckEnabled = null,
    Object? defaultPasswordLength = null,
    Object? includeUppercase = null,
    Object? includeLowercase = null,
    Object? includeDigits = null,
    Object? includeSymbols = null,
    Object? excludedCharacters = null,
    Object? lastBackupDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            autoLockTimeoutSeconds: null == autoLockTimeoutSeconds
                ? _value.autoLockTimeoutSeconds
                : autoLockTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            clipboardClearSeconds: null == clipboardClearSeconds
                ? _value.clipboardClearSeconds
                : clipboardClearSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            biometricsEnabled: null == biometricsEnabled
                ? _value.biometricsEnabled
                : biometricsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            showPasswordStrength: null == showPasswordStrength
                ? _value.showPasswordStrength
                : showPasswordStrength // ignore: cast_nullable_to_non_nullable
                      as bool,
            breachCheckEnabled: null == breachCheckEnabled
                ? _value.breachCheckEnabled
                : breachCheckEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            defaultPasswordLength: null == defaultPasswordLength
                ? _value.defaultPasswordLength
                : defaultPasswordLength // ignore: cast_nullable_to_non_nullable
                      as int,
            includeUppercase: null == includeUppercase
                ? _value.includeUppercase
                : includeUppercase // ignore: cast_nullable_to_non_nullable
                      as bool,
            includeLowercase: null == includeLowercase
                ? _value.includeLowercase
                : includeLowercase // ignore: cast_nullable_to_non_nullable
                      as bool,
            includeDigits: null == includeDigits
                ? _value.includeDigits
                : includeDigits // ignore: cast_nullable_to_non_nullable
                      as bool,
            includeSymbols: null == includeSymbols
                ? _value.includeSymbols
                : includeSymbols // ignore: cast_nullable_to_non_nullable
                      as bool,
            excludedCharacters: null == excludedCharacters
                ? _value.excludedCharacters
                : excludedCharacters // ignore: cast_nullable_to_non_nullable
                      as String,
            lastBackupDate: freezed == lastBackupDate
                ? _value.lastBackupDate
                : lastBackupDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @ThemeModeConverter() ThemeMode themeMode,
    int autoLockTimeoutSeconds,
    int clipboardClearSeconds,
    bool biometricsEnabled,
    bool showPasswordStrength,
    bool breachCheckEnabled,
    int defaultPasswordLength,
    bool includeUppercase,
    bool includeLowercase,
    bool includeDigits,
    bool includeSymbols,
    String excludedCharacters,
    DateTime? lastBackupDate,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? autoLockTimeoutSeconds = null,
    Object? clipboardClearSeconds = null,
    Object? biometricsEnabled = null,
    Object? showPasswordStrength = null,
    Object? breachCheckEnabled = null,
    Object? defaultPasswordLength = null,
    Object? includeUppercase = null,
    Object? includeLowercase = null,
    Object? includeDigits = null,
    Object? includeSymbols = null,
    Object? excludedCharacters = null,
    Object? lastBackupDate = freezed,
  }) {
    return _then(
      _$AppSettingsImpl(
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        autoLockTimeoutSeconds: null == autoLockTimeoutSeconds
            ? _value.autoLockTimeoutSeconds
            : autoLockTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        clipboardClearSeconds: null == clipboardClearSeconds
            ? _value.clipboardClearSeconds
            : clipboardClearSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        biometricsEnabled: null == biometricsEnabled
            ? _value.biometricsEnabled
            : biometricsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        showPasswordStrength: null == showPasswordStrength
            ? _value.showPasswordStrength
            : showPasswordStrength // ignore: cast_nullable_to_non_nullable
                  as bool,
        breachCheckEnabled: null == breachCheckEnabled
            ? _value.breachCheckEnabled
            : breachCheckEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        defaultPasswordLength: null == defaultPasswordLength
            ? _value.defaultPasswordLength
            : defaultPasswordLength // ignore: cast_nullable_to_non_nullable
                  as int,
        includeUppercase: null == includeUppercase
            ? _value.includeUppercase
            : includeUppercase // ignore: cast_nullable_to_non_nullable
                  as bool,
        includeLowercase: null == includeLowercase
            ? _value.includeLowercase
            : includeLowercase // ignore: cast_nullable_to_non_nullable
                  as bool,
        includeDigits: null == includeDigits
            ? _value.includeDigits
            : includeDigits // ignore: cast_nullable_to_non_nullable
                  as bool,
        includeSymbols: null == includeSymbols
            ? _value.includeSymbols
            : includeSymbols // ignore: cast_nullable_to_non_nullable
                  as bool,
        excludedCharacters: null == excludedCharacters
            ? _value.excludedCharacters
            : excludedCharacters // ignore: cast_nullable_to_non_nullable
                  as String,
        lastBackupDate: freezed == lastBackupDate
            ? _value.lastBackupDate
            : lastBackupDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    @ThemeModeConverter() this.themeMode = ThemeMode.system,
    this.autoLockTimeoutSeconds = 300,
    this.clipboardClearSeconds = 30,
    this.biometricsEnabled = false,
    this.showPasswordStrength = true,
    this.breachCheckEnabled = true,
    this.defaultPasswordLength = 16,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeDigits = true,
    this.includeSymbols = true,
    this.excludedCharacters = '',
    this.lastBackupDate,
  });

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  @ThemeModeConverter()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final int autoLockTimeoutSeconds;
  @override
  @JsonKey()
  final int clipboardClearSeconds;
  @override
  @JsonKey()
  final bool biometricsEnabled;
  @override
  @JsonKey()
  final bool showPasswordStrength;
  @override
  @JsonKey()
  final bool breachCheckEnabled;
  @override
  @JsonKey()
  final int defaultPasswordLength;
  @override
  @JsonKey()
  final bool includeUppercase;
  @override
  @JsonKey()
  final bool includeLowercase;
  @override
  @JsonKey()
  final bool includeDigits;
  @override
  @JsonKey()
  final bool includeSymbols;
  @override
  @JsonKey()
  final String excludedCharacters;
  @override
  final DateTime? lastBackupDate;

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, autoLockTimeoutSeconds: $autoLockTimeoutSeconds, clipboardClearSeconds: $clipboardClearSeconds, biometricsEnabled: $biometricsEnabled, showPasswordStrength: $showPasswordStrength, breachCheckEnabled: $breachCheckEnabled, defaultPasswordLength: $defaultPasswordLength, includeUppercase: $includeUppercase, includeLowercase: $includeLowercase, includeDigits: $includeDigits, includeSymbols: $includeSymbols, excludedCharacters: $excludedCharacters, lastBackupDate: $lastBackupDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.autoLockTimeoutSeconds, autoLockTimeoutSeconds) ||
                other.autoLockTimeoutSeconds == autoLockTimeoutSeconds) &&
            (identical(other.clipboardClearSeconds, clipboardClearSeconds) ||
                other.clipboardClearSeconds == clipboardClearSeconds) &&
            (identical(other.biometricsEnabled, biometricsEnabled) ||
                other.biometricsEnabled == biometricsEnabled) &&
            (identical(other.showPasswordStrength, showPasswordStrength) ||
                other.showPasswordStrength == showPasswordStrength) &&
            (identical(other.breachCheckEnabled, breachCheckEnabled) ||
                other.breachCheckEnabled == breachCheckEnabled) &&
            (identical(other.defaultPasswordLength, defaultPasswordLength) ||
                other.defaultPasswordLength == defaultPasswordLength) &&
            (identical(other.includeUppercase, includeUppercase) ||
                other.includeUppercase == includeUppercase) &&
            (identical(other.includeLowercase, includeLowercase) ||
                other.includeLowercase == includeLowercase) &&
            (identical(other.includeDigits, includeDigits) ||
                other.includeDigits == includeDigits) &&
            (identical(other.includeSymbols, includeSymbols) ||
                other.includeSymbols == includeSymbols) &&
            (identical(other.excludedCharacters, excludedCharacters) ||
                other.excludedCharacters == excludedCharacters) &&
            (identical(other.lastBackupDate, lastBackupDate) ||
                other.lastBackupDate == lastBackupDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    themeMode,
    autoLockTimeoutSeconds,
    clipboardClearSeconds,
    biometricsEnabled,
    showPasswordStrength,
    breachCheckEnabled,
    defaultPasswordLength,
    includeUppercase,
    includeLowercase,
    includeDigits,
    includeSymbols,
    excludedCharacters,
    lastBackupDate,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    @ThemeModeConverter() final ThemeMode themeMode,
    final int autoLockTimeoutSeconds,
    final int clipboardClearSeconds,
    final bool biometricsEnabled,
    final bool showPasswordStrength,
    final bool breachCheckEnabled,
    final int defaultPasswordLength,
    final bool includeUppercase,
    final bool includeLowercase,
    final bool includeDigits,
    final bool includeSymbols,
    final String excludedCharacters,
    final DateTime? lastBackupDate,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @ThemeModeConverter()
  ThemeMode get themeMode;
  @override
  int get autoLockTimeoutSeconds;
  @override
  int get clipboardClearSeconds;
  @override
  bool get biometricsEnabled;
  @override
  bool get showPasswordStrength;
  @override
  bool get breachCheckEnabled;
  @override
  int get defaultPasswordLength;
  @override
  bool get includeUppercase;
  @override
  bool get includeLowercase;
  @override
  bool get includeDigits;
  @override
  bool get includeSymbols;
  @override
  String get excludedCharacters;
  @override
  DateTime? get lastBackupDate;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
