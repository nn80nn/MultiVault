// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PasswordHistory _$PasswordHistoryFromJson(Map<String, dynamic> json) {
  return _PasswordHistory.fromJson(json);
}

/// @nodoc
mixin _$PasswordHistory {
  String get id => throw _privateConstructorUsedError;
  String get entryId => throw _privateConstructorUsedError;
  String get encryptedOldPassword => throw _privateConstructorUsedError;
  String get changedBy => throw _privateConstructorUsedError;
  DateTime get changedAt => throw _privateConstructorUsedError;

  /// Serializes this PasswordHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordHistoryCopyWith<PasswordHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordHistoryCopyWith<$Res> {
  factory $PasswordHistoryCopyWith(
    PasswordHistory value,
    $Res Function(PasswordHistory) then,
  ) = _$PasswordHistoryCopyWithImpl<$Res, PasswordHistory>;
  @useResult
  $Res call({
    String id,
    String entryId,
    String encryptedOldPassword,
    String changedBy,
    DateTime changedAt,
  });
}

/// @nodoc
class _$PasswordHistoryCopyWithImpl<$Res, $Val extends PasswordHistory>
    implements $PasswordHistoryCopyWith<$Res> {
  _$PasswordHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entryId = null,
    Object? encryptedOldPassword = null,
    Object? changedBy = null,
    Object? changedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            entryId: null == entryId
                ? _value.entryId
                : entryId // ignore: cast_nullable_to_non_nullable
                      as String,
            encryptedOldPassword: null == encryptedOldPassword
                ? _value.encryptedOldPassword
                : encryptedOldPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            changedBy: null == changedBy
                ? _value.changedBy
                : changedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            changedAt: null == changedAt
                ? _value.changedAt
                : changedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordHistoryImplCopyWith<$Res>
    implements $PasswordHistoryCopyWith<$Res> {
  factory _$$PasswordHistoryImplCopyWith(
    _$PasswordHistoryImpl value,
    $Res Function(_$PasswordHistoryImpl) then,
  ) = __$$PasswordHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String entryId,
    String encryptedOldPassword,
    String changedBy,
    DateTime changedAt,
  });
}

/// @nodoc
class __$$PasswordHistoryImplCopyWithImpl<$Res>
    extends _$PasswordHistoryCopyWithImpl<$Res, _$PasswordHistoryImpl>
    implements _$$PasswordHistoryImplCopyWith<$Res> {
  __$$PasswordHistoryImplCopyWithImpl(
    _$PasswordHistoryImpl _value,
    $Res Function(_$PasswordHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entryId = null,
    Object? encryptedOldPassword = null,
    Object? changedBy = null,
    Object? changedAt = null,
  }) {
    return _then(
      _$PasswordHistoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        entryId: null == entryId
            ? _value.entryId
            : entryId // ignore: cast_nullable_to_non_nullable
                  as String,
        encryptedOldPassword: null == encryptedOldPassword
            ? _value.encryptedOldPassword
            : encryptedOldPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        changedBy: null == changedBy
            ? _value.changedBy
            : changedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        changedAt: null == changedAt
            ? _value.changedAt
            : changedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordHistoryImpl implements _PasswordHistory {
  const _$PasswordHistoryImpl({
    required this.id,
    required this.entryId,
    required this.encryptedOldPassword,
    this.changedBy = 'user',
    required this.changedAt,
  });

  factory _$PasswordHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String entryId;
  @override
  final String encryptedOldPassword;
  @override
  @JsonKey()
  final String changedBy;
  @override
  final DateTime changedAt;

  @override
  String toString() {
    return 'PasswordHistory(id: $id, entryId: $entryId, encryptedOldPassword: $encryptedOldPassword, changedBy: $changedBy, changedAt: $changedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.encryptedOldPassword, encryptedOldPassword) ||
                other.encryptedOldPassword == encryptedOldPassword) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entryId,
    encryptedOldPassword,
    changedBy,
    changedAt,
  );

  /// Create a copy of PasswordHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordHistoryImplCopyWith<_$PasswordHistoryImpl> get copyWith =>
      __$$PasswordHistoryImplCopyWithImpl<_$PasswordHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordHistoryImplToJson(this);
  }
}

abstract class _PasswordHistory implements PasswordHistory {
  const factory _PasswordHistory({
    required final String id,
    required final String entryId,
    required final String encryptedOldPassword,
    final String changedBy,
    required final DateTime changedAt,
  }) = _$PasswordHistoryImpl;

  factory _PasswordHistory.fromJson(Map<String, dynamic> json) =
      _$PasswordHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get entryId;
  @override
  String get encryptedOldPassword;
  @override
  String get changedBy;
  @override
  DateTime get changedAt;

  /// Create a copy of PasswordHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordHistoryImplCopyWith<_$PasswordHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
