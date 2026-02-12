// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generator_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeneratorConfig _$GeneratorConfigFromJson(Map<String, dynamic> json) {
  return _GeneratorConfig.fromJson(json);
}

/// @nodoc
mixin _$GeneratorConfig {
  int get length => throw _privateConstructorUsedError;
  bool get uppercase => throw _privateConstructorUsedError;
  bool get lowercase => throw _privateConstructorUsedError;
  bool get digits => throw _privateConstructorUsedError;
  bool get symbols => throw _privateConstructorUsedError;
  String get excludeCharacters => throw _privateConstructorUsedError;

  /// Serializes this GeneratorConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneratorConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneratorConfigCopyWith<GeneratorConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratorConfigCopyWith<$Res> {
  factory $GeneratorConfigCopyWith(
    GeneratorConfig value,
    $Res Function(GeneratorConfig) then,
  ) = _$GeneratorConfigCopyWithImpl<$Res, GeneratorConfig>;
  @useResult
  $Res call({
    int length,
    bool uppercase,
    bool lowercase,
    bool digits,
    bool symbols,
    String excludeCharacters,
  });
}

/// @nodoc
class _$GeneratorConfigCopyWithImpl<$Res, $Val extends GeneratorConfig>
    implements $GeneratorConfigCopyWith<$Res> {
  _$GeneratorConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneratorConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? length = null,
    Object? uppercase = null,
    Object? lowercase = null,
    Object? digits = null,
    Object? symbols = null,
    Object? excludeCharacters = null,
  }) {
    return _then(
      _value.copyWith(
            length: null == length
                ? _value.length
                : length // ignore: cast_nullable_to_non_nullable
                      as int,
            uppercase: null == uppercase
                ? _value.uppercase
                : uppercase // ignore: cast_nullable_to_non_nullable
                      as bool,
            lowercase: null == lowercase
                ? _value.lowercase
                : lowercase // ignore: cast_nullable_to_non_nullable
                      as bool,
            digits: null == digits
                ? _value.digits
                : digits // ignore: cast_nullable_to_non_nullable
                      as bool,
            symbols: null == symbols
                ? _value.symbols
                : symbols // ignore: cast_nullable_to_non_nullable
                      as bool,
            excludeCharacters: null == excludeCharacters
                ? _value.excludeCharacters
                : excludeCharacters // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeneratorConfigImplCopyWith<$Res>
    implements $GeneratorConfigCopyWith<$Res> {
  factory _$$GeneratorConfigImplCopyWith(
    _$GeneratorConfigImpl value,
    $Res Function(_$GeneratorConfigImpl) then,
  ) = __$$GeneratorConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int length,
    bool uppercase,
    bool lowercase,
    bool digits,
    bool symbols,
    String excludeCharacters,
  });
}

/// @nodoc
class __$$GeneratorConfigImplCopyWithImpl<$Res>
    extends _$GeneratorConfigCopyWithImpl<$Res, _$GeneratorConfigImpl>
    implements _$$GeneratorConfigImplCopyWith<$Res> {
  __$$GeneratorConfigImplCopyWithImpl(
    _$GeneratorConfigImpl _value,
    $Res Function(_$GeneratorConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeneratorConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? length = null,
    Object? uppercase = null,
    Object? lowercase = null,
    Object? digits = null,
    Object? symbols = null,
    Object? excludeCharacters = null,
  }) {
    return _then(
      _$GeneratorConfigImpl(
        length: null == length
            ? _value.length
            : length // ignore: cast_nullable_to_non_nullable
                  as int,
        uppercase: null == uppercase
            ? _value.uppercase
            : uppercase // ignore: cast_nullable_to_non_nullable
                  as bool,
        lowercase: null == lowercase
            ? _value.lowercase
            : lowercase // ignore: cast_nullable_to_non_nullable
                  as bool,
        digits: null == digits
            ? _value.digits
            : digits // ignore: cast_nullable_to_non_nullable
                  as bool,
        symbols: null == symbols
            ? _value.symbols
            : symbols // ignore: cast_nullable_to_non_nullable
                  as bool,
        excludeCharacters: null == excludeCharacters
            ? _value.excludeCharacters
            : excludeCharacters // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneratorConfigImpl implements _GeneratorConfig {
  const _$GeneratorConfigImpl({
    this.length = 16,
    this.uppercase = true,
    this.lowercase = true,
    this.digits = true,
    this.symbols = true,
    this.excludeCharacters = '',
  });

  factory _$GeneratorConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneratorConfigImplFromJson(json);

  @override
  @JsonKey()
  final int length;
  @override
  @JsonKey()
  final bool uppercase;
  @override
  @JsonKey()
  final bool lowercase;
  @override
  @JsonKey()
  final bool digits;
  @override
  @JsonKey()
  final bool symbols;
  @override
  @JsonKey()
  final String excludeCharacters;

  @override
  String toString() {
    return 'GeneratorConfig(length: $length, uppercase: $uppercase, lowercase: $lowercase, digits: $digits, symbols: $symbols, excludeCharacters: $excludeCharacters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratorConfigImpl &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.uppercase, uppercase) ||
                other.uppercase == uppercase) &&
            (identical(other.lowercase, lowercase) ||
                other.lowercase == lowercase) &&
            (identical(other.digits, digits) || other.digits == digits) &&
            (identical(other.symbols, symbols) || other.symbols == symbols) &&
            (identical(other.excludeCharacters, excludeCharacters) ||
                other.excludeCharacters == excludeCharacters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    length,
    uppercase,
    lowercase,
    digits,
    symbols,
    excludeCharacters,
  );

  /// Create a copy of GeneratorConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratorConfigImplCopyWith<_$GeneratorConfigImpl> get copyWith =>
      __$$GeneratorConfigImplCopyWithImpl<_$GeneratorConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneratorConfigImplToJson(this);
  }
}

abstract class _GeneratorConfig implements GeneratorConfig {
  const factory _GeneratorConfig({
    final int length,
    final bool uppercase,
    final bool lowercase,
    final bool digits,
    final bool symbols,
    final String excludeCharacters,
  }) = _$GeneratorConfigImpl;

  factory _GeneratorConfig.fromJson(Map<String, dynamic> json) =
      _$GeneratorConfigImpl.fromJson;

  @override
  int get length;
  @override
  bool get uppercase;
  @override
  bool get lowercase;
  @override
  bool get digits;
  @override
  bool get symbols;
  @override
  String get excludeCharacters;

  /// Create a copy of GeneratorConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratorConfigImplCopyWith<_$GeneratorConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
