// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'master_password_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MasterPasswordConfig _$MasterPasswordConfigFromJson(Map<String, dynamic> json) {
  return _MasterPasswordConfig.fromJson(json);
}

/// @nodoc
mixin _$MasterPasswordConfig {
  String get passwordHash => throw _privateConstructorUsedError;
  String get salt => throw _privateConstructorUsedError;
  int get iterations => throw _privateConstructorUsedError;
  int get keyLength => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastChangedAt => throw _privateConstructorUsedError;
  bool get biometricsEnabled => throw _privateConstructorUsedError;

  /// Serializes this MasterPasswordConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MasterPasswordConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MasterPasswordConfigCopyWith<MasterPasswordConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasterPasswordConfigCopyWith<$Res> {
  factory $MasterPasswordConfigCopyWith(
    MasterPasswordConfig value,
    $Res Function(MasterPasswordConfig) then,
  ) = _$MasterPasswordConfigCopyWithImpl<$Res, MasterPasswordConfig>;
  @useResult
  $Res call({
    String passwordHash,
    String salt,
    int iterations,
    int keyLength,
    DateTime createdAt,
    DateTime? lastChangedAt,
    bool biometricsEnabled,
  });
}

/// @nodoc
class _$MasterPasswordConfigCopyWithImpl<
  $Res,
  $Val extends MasterPasswordConfig
>
    implements $MasterPasswordConfigCopyWith<$Res> {
  _$MasterPasswordConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MasterPasswordConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? passwordHash = null,
    Object? salt = null,
    Object? iterations = null,
    Object? keyLength = null,
    Object? createdAt = null,
    Object? lastChangedAt = freezed,
    Object? biometricsEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            passwordHash: null == passwordHash
                ? _value.passwordHash
                : passwordHash // ignore: cast_nullable_to_non_nullable
                      as String,
            salt: null == salt
                ? _value.salt
                : salt // ignore: cast_nullable_to_non_nullable
                      as String,
            iterations: null == iterations
                ? _value.iterations
                : iterations // ignore: cast_nullable_to_non_nullable
                      as int,
            keyLength: null == keyLength
                ? _value.keyLength
                : keyLength // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastChangedAt: freezed == lastChangedAt
                ? _value.lastChangedAt
                : lastChangedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            biometricsEnabled: null == biometricsEnabled
                ? _value.biometricsEnabled
                : biometricsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MasterPasswordConfigImplCopyWith<$Res>
    implements $MasterPasswordConfigCopyWith<$Res> {
  factory _$$MasterPasswordConfigImplCopyWith(
    _$MasterPasswordConfigImpl value,
    $Res Function(_$MasterPasswordConfigImpl) then,
  ) = __$$MasterPasswordConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String passwordHash,
    String salt,
    int iterations,
    int keyLength,
    DateTime createdAt,
    DateTime? lastChangedAt,
    bool biometricsEnabled,
  });
}

/// @nodoc
class __$$MasterPasswordConfigImplCopyWithImpl<$Res>
    extends _$MasterPasswordConfigCopyWithImpl<$Res, _$MasterPasswordConfigImpl>
    implements _$$MasterPasswordConfigImplCopyWith<$Res> {
  __$$MasterPasswordConfigImplCopyWithImpl(
    _$MasterPasswordConfigImpl _value,
    $Res Function(_$MasterPasswordConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MasterPasswordConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? passwordHash = null,
    Object? salt = null,
    Object? iterations = null,
    Object? keyLength = null,
    Object? createdAt = null,
    Object? lastChangedAt = freezed,
    Object? biometricsEnabled = null,
  }) {
    return _then(
      _$MasterPasswordConfigImpl(
        passwordHash: null == passwordHash
            ? _value.passwordHash
            : passwordHash // ignore: cast_nullable_to_non_nullable
                  as String,
        salt: null == salt
            ? _value.salt
            : salt // ignore: cast_nullable_to_non_nullable
                  as String,
        iterations: null == iterations
            ? _value.iterations
            : iterations // ignore: cast_nullable_to_non_nullable
                  as int,
        keyLength: null == keyLength
            ? _value.keyLength
            : keyLength // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastChangedAt: freezed == lastChangedAt
            ? _value.lastChangedAt
            : lastChangedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        biometricsEnabled: null == biometricsEnabled
            ? _value.biometricsEnabled
            : biometricsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MasterPasswordConfigImpl implements _MasterPasswordConfig {
  const _$MasterPasswordConfigImpl({
    required this.passwordHash,
    required this.salt,
    required this.iterations,
    required this.keyLength,
    required this.createdAt,
    this.lastChangedAt,
    this.biometricsEnabled = false,
  });

  factory _$MasterPasswordConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$MasterPasswordConfigImplFromJson(json);

  @override
  final String passwordHash;
  @override
  final String salt;
  @override
  final int iterations;
  @override
  final int keyLength;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastChangedAt;
  @override
  @JsonKey()
  final bool biometricsEnabled;

  @override
  String toString() {
    return 'MasterPasswordConfig(passwordHash: $passwordHash, salt: $salt, iterations: $iterations, keyLength: $keyLength, createdAt: $createdAt, lastChangedAt: $lastChangedAt, biometricsEnabled: $biometricsEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MasterPasswordConfigImpl &&
            (identical(other.passwordHash, passwordHash) ||
                other.passwordHash == passwordHash) &&
            (identical(other.salt, salt) || other.salt == salt) &&
            (identical(other.iterations, iterations) ||
                other.iterations == iterations) &&
            (identical(other.keyLength, keyLength) ||
                other.keyLength == keyLength) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastChangedAt, lastChangedAt) ||
                other.lastChangedAt == lastChangedAt) &&
            (identical(other.biometricsEnabled, biometricsEnabled) ||
                other.biometricsEnabled == biometricsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    passwordHash,
    salt,
    iterations,
    keyLength,
    createdAt,
    lastChangedAt,
    biometricsEnabled,
  );

  /// Create a copy of MasterPasswordConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MasterPasswordConfigImplCopyWith<_$MasterPasswordConfigImpl>
  get copyWith =>
      __$$MasterPasswordConfigImplCopyWithImpl<_$MasterPasswordConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MasterPasswordConfigImplToJson(this);
  }
}

abstract class _MasterPasswordConfig implements MasterPasswordConfig {
  const factory _MasterPasswordConfig({
    required final String passwordHash,
    required final String salt,
    required final int iterations,
    required final int keyLength,
    required final DateTime createdAt,
    final DateTime? lastChangedAt,
    final bool biometricsEnabled,
  }) = _$MasterPasswordConfigImpl;

  factory _MasterPasswordConfig.fromJson(Map<String, dynamic> json) =
      _$MasterPasswordConfigImpl.fromJson;

  @override
  String get passwordHash;
  @override
  String get salt;
  @override
  int get iterations;
  @override
  int get keyLength;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastChangedAt;
  @override
  bool get biometricsEnabled;

  /// Create a copy of MasterPasswordConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MasterPasswordConfigImplCopyWith<_$MasterPasswordConfigImpl>
  get copyWith => throw _privateConstructorUsedError;
}
