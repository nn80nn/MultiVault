// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExportConfig _$ExportConfigFromJson(Map<String, dynamic> json) {
  return _ExportConfig.fromJson(json);
}

/// @nodoc
mixin _$ExportConfig {
  ExportFormat get format => throw _privateConstructorUsedError;
  bool get includeHistory => throw _privateConstructorUsedError;
  bool get encrypted => throw _privateConstructorUsedError;
  String? get exportPassword => throw _privateConstructorUsedError;

  /// Serializes this ExportConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExportConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportConfigCopyWith<ExportConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportConfigCopyWith<$Res> {
  factory $ExportConfigCopyWith(
    ExportConfig value,
    $Res Function(ExportConfig) then,
  ) = _$ExportConfigCopyWithImpl<$Res, ExportConfig>;
  @useResult
  $Res call({
    ExportFormat format,
    bool includeHistory,
    bool encrypted,
    String? exportPassword,
  });
}

/// @nodoc
class _$ExportConfigCopyWithImpl<$Res, $Val extends ExportConfig>
    implements $ExportConfigCopyWith<$Res> {
  _$ExportConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? format = null,
    Object? includeHistory = null,
    Object? encrypted = null,
    Object? exportPassword = freezed,
  }) {
    return _then(
      _value.copyWith(
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as ExportFormat,
            includeHistory: null == includeHistory
                ? _value.includeHistory
                : includeHistory // ignore: cast_nullable_to_non_nullable
                      as bool,
            encrypted: null == encrypted
                ? _value.encrypted
                : encrypted // ignore: cast_nullable_to_non_nullable
                      as bool,
            exportPassword: freezed == exportPassword
                ? _value.exportPassword
                : exportPassword // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExportConfigImplCopyWith<$Res>
    implements $ExportConfigCopyWith<$Res> {
  factory _$$ExportConfigImplCopyWith(
    _$ExportConfigImpl value,
    $Res Function(_$ExportConfigImpl) then,
  ) = __$$ExportConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ExportFormat format,
    bool includeHistory,
    bool encrypted,
    String? exportPassword,
  });
}

/// @nodoc
class __$$ExportConfigImplCopyWithImpl<$Res>
    extends _$ExportConfigCopyWithImpl<$Res, _$ExportConfigImpl>
    implements _$$ExportConfigImplCopyWith<$Res> {
  __$$ExportConfigImplCopyWithImpl(
    _$ExportConfigImpl _value,
    $Res Function(_$ExportConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExportConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? format = null,
    Object? includeHistory = null,
    Object? encrypted = null,
    Object? exportPassword = freezed,
  }) {
    return _then(
      _$ExportConfigImpl(
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as ExportFormat,
        includeHistory: null == includeHistory
            ? _value.includeHistory
            : includeHistory // ignore: cast_nullable_to_non_nullable
                  as bool,
        encrypted: null == encrypted
            ? _value.encrypted
            : encrypted // ignore: cast_nullable_to_non_nullable
                  as bool,
        exportPassword: freezed == exportPassword
            ? _value.exportPassword
            : exportPassword // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportConfigImpl implements _ExportConfig {
  const _$ExportConfigImpl({
    required this.format,
    this.includeHistory = true,
    this.encrypted = true,
    this.exportPassword,
  });

  factory _$ExportConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportConfigImplFromJson(json);

  @override
  final ExportFormat format;
  @override
  @JsonKey()
  final bool includeHistory;
  @override
  @JsonKey()
  final bool encrypted;
  @override
  final String? exportPassword;

  @override
  String toString() {
    return 'ExportConfig(format: $format, includeHistory: $includeHistory, encrypted: $encrypted, exportPassword: $exportPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportConfigImpl &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.includeHistory, includeHistory) ||
                other.includeHistory == includeHistory) &&
            (identical(other.encrypted, encrypted) ||
                other.encrypted == encrypted) &&
            (identical(other.exportPassword, exportPassword) ||
                other.exportPassword == exportPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    format,
    includeHistory,
    encrypted,
    exportPassword,
  );

  /// Create a copy of ExportConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportConfigImplCopyWith<_$ExportConfigImpl> get copyWith =>
      __$$ExportConfigImplCopyWithImpl<_$ExportConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportConfigImplToJson(this);
  }
}

abstract class _ExportConfig implements ExportConfig {
  const factory _ExportConfig({
    required final ExportFormat format,
    final bool includeHistory,
    final bool encrypted,
    final String? exportPassword,
  }) = _$ExportConfigImpl;

  factory _ExportConfig.fromJson(Map<String, dynamic> json) =
      _$ExportConfigImpl.fromJson;

  @override
  ExportFormat get format;
  @override
  bool get includeHistory;
  @override
  bool get encrypted;
  @override
  String? get exportPassword;

  /// Create a copy of ExportConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportConfigImplCopyWith<_$ExportConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
