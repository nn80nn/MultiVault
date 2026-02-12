// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breach_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BreachResult _$BreachResultFromJson(Map<String, dynamic> json) {
  return _BreachResult.fromJson(json);
}

/// @nodoc
mixin _$BreachResult {
  bool get isBreached => throw _privateConstructorUsedError;
  int get occurrenceCount => throw _privateConstructorUsedError;
  DateTime get checkedAt => throw _privateConstructorUsedError;

  /// Serializes this BreachResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreachResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreachResultCopyWith<BreachResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreachResultCopyWith<$Res> {
  factory $BreachResultCopyWith(
    BreachResult value,
    $Res Function(BreachResult) then,
  ) = _$BreachResultCopyWithImpl<$Res, BreachResult>;
  @useResult
  $Res call({bool isBreached, int occurrenceCount, DateTime checkedAt});
}

/// @nodoc
class _$BreachResultCopyWithImpl<$Res, $Val extends BreachResult>
    implements $BreachResultCopyWith<$Res> {
  _$BreachResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreachResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBreached = null,
    Object? occurrenceCount = null,
    Object? checkedAt = null,
  }) {
    return _then(
      _value.copyWith(
            isBreached: null == isBreached
                ? _value.isBreached
                : isBreached // ignore: cast_nullable_to_non_nullable
                      as bool,
            occurrenceCount: null == occurrenceCount
                ? _value.occurrenceCount
                : occurrenceCount // ignore: cast_nullable_to_non_nullable
                      as int,
            checkedAt: null == checkedAt
                ? _value.checkedAt
                : checkedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreachResultImplCopyWith<$Res>
    implements $BreachResultCopyWith<$Res> {
  factory _$$BreachResultImplCopyWith(
    _$BreachResultImpl value,
    $Res Function(_$BreachResultImpl) then,
  ) = __$$BreachResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBreached, int occurrenceCount, DateTime checkedAt});
}

/// @nodoc
class __$$BreachResultImplCopyWithImpl<$Res>
    extends _$BreachResultCopyWithImpl<$Res, _$BreachResultImpl>
    implements _$$BreachResultImplCopyWith<$Res> {
  __$$BreachResultImplCopyWithImpl(
    _$BreachResultImpl _value,
    $Res Function(_$BreachResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreachResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBreached = null,
    Object? occurrenceCount = null,
    Object? checkedAt = null,
  }) {
    return _then(
      _$BreachResultImpl(
        isBreached: null == isBreached
            ? _value.isBreached
            : isBreached // ignore: cast_nullable_to_non_nullable
                  as bool,
        occurrenceCount: null == occurrenceCount
            ? _value.occurrenceCount
            : occurrenceCount // ignore: cast_nullable_to_non_nullable
                  as int,
        checkedAt: null == checkedAt
            ? _value.checkedAt
            : checkedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreachResultImpl implements _BreachResult {
  const _$BreachResultImpl({
    required this.isBreached,
    required this.occurrenceCount,
    required this.checkedAt,
  });

  factory _$BreachResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreachResultImplFromJson(json);

  @override
  final bool isBreached;
  @override
  final int occurrenceCount;
  @override
  final DateTime checkedAt;

  @override
  String toString() {
    return 'BreachResult(isBreached: $isBreached, occurrenceCount: $occurrenceCount, checkedAt: $checkedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreachResultImpl &&
            (identical(other.isBreached, isBreached) ||
                other.isBreached == isBreached) &&
            (identical(other.occurrenceCount, occurrenceCount) ||
                other.occurrenceCount == occurrenceCount) &&
            (identical(other.checkedAt, checkedAt) ||
                other.checkedAt == checkedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isBreached, occurrenceCount, checkedAt);

  /// Create a copy of BreachResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreachResultImplCopyWith<_$BreachResultImpl> get copyWith =>
      __$$BreachResultImplCopyWithImpl<_$BreachResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreachResultImplToJson(this);
  }
}

abstract class _BreachResult implements BreachResult {
  const factory _BreachResult({
    required final bool isBreached,
    required final int occurrenceCount,
    required final DateTime checkedAt,
  }) = _$BreachResultImpl;

  factory _BreachResult.fromJson(Map<String, dynamic> json) =
      _$BreachResultImpl.fromJson;

  @override
  bool get isBreached;
  @override
  int get occurrenceCount;
  @override
  DateTime get checkedAt;

  /// Create a copy of BreachResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreachResultImplCopyWith<_$BreachResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
