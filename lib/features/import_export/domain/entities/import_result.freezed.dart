// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ImportResult _$ImportResultFromJson(Map<String, dynamic> json) {
  return _ImportResult.fromJson(json);
}

/// @nodoc
mixin _$ImportResult {
  int get totalParsed => throw _privateConstructorUsedError;
  int get successfullyImported => throw _privateConstructorUsedError;
  int get skippedDuplicates => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;
  String get sourceFormat => throw _privateConstructorUsedError;
  DateTime get importedAt => throw _privateConstructorUsedError;

  /// Serializes this ImportResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportResultCopyWith<ImportResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportResultCopyWith<$Res> {
  factory $ImportResultCopyWith(
    ImportResult value,
    $Res Function(ImportResult) then,
  ) = _$ImportResultCopyWithImpl<$Res, ImportResult>;
  @useResult
  $Res call({
    int totalParsed,
    int successfullyImported,
    int skippedDuplicates,
    List<String> errors,
    String sourceFormat,
    DateTime importedAt,
  });
}

/// @nodoc
class _$ImportResultCopyWithImpl<$Res, $Val extends ImportResult>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalParsed = null,
    Object? successfullyImported = null,
    Object? skippedDuplicates = null,
    Object? errors = null,
    Object? sourceFormat = null,
    Object? importedAt = null,
  }) {
    return _then(
      _value.copyWith(
            totalParsed: null == totalParsed
                ? _value.totalParsed
                : totalParsed // ignore: cast_nullable_to_non_nullable
                      as int,
            successfullyImported: null == successfullyImported
                ? _value.successfullyImported
                : successfullyImported // ignore: cast_nullable_to_non_nullable
                      as int,
            skippedDuplicates: null == skippedDuplicates
                ? _value.skippedDuplicates
                : skippedDuplicates // ignore: cast_nullable_to_non_nullable
                      as int,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sourceFormat: null == sourceFormat
                ? _value.sourceFormat
                : sourceFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            importedAt: null == importedAt
                ? _value.importedAt
                : importedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImportResultImplCopyWith<$Res>
    implements $ImportResultCopyWith<$Res> {
  factory _$$ImportResultImplCopyWith(
    _$ImportResultImpl value,
    $Res Function(_$ImportResultImpl) then,
  ) = __$$ImportResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalParsed,
    int successfullyImported,
    int skippedDuplicates,
    List<String> errors,
    String sourceFormat,
    DateTime importedAt,
  });
}

/// @nodoc
class __$$ImportResultImplCopyWithImpl<$Res>
    extends _$ImportResultCopyWithImpl<$Res, _$ImportResultImpl>
    implements _$$ImportResultImplCopyWith<$Res> {
  __$$ImportResultImplCopyWithImpl(
    _$ImportResultImpl _value,
    $Res Function(_$ImportResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalParsed = null,
    Object? successfullyImported = null,
    Object? skippedDuplicates = null,
    Object? errors = null,
    Object? sourceFormat = null,
    Object? importedAt = null,
  }) {
    return _then(
      _$ImportResultImpl(
        totalParsed: null == totalParsed
            ? _value.totalParsed
            : totalParsed // ignore: cast_nullable_to_non_nullable
                  as int,
        successfullyImported: null == successfullyImported
            ? _value.successfullyImported
            : successfullyImported // ignore: cast_nullable_to_non_nullable
                  as int,
        skippedDuplicates: null == skippedDuplicates
            ? _value.skippedDuplicates
            : skippedDuplicates // ignore: cast_nullable_to_non_nullable
                  as int,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sourceFormat: null == sourceFormat
            ? _value.sourceFormat
            : sourceFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        importedAt: null == importedAt
            ? _value.importedAt
            : importedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportResultImpl implements _ImportResult {
  const _$ImportResultImpl({
    required this.totalParsed,
    required this.successfullyImported,
    required this.skippedDuplicates,
    required final List<String> errors,
    required this.sourceFormat,
    required this.importedAt,
  }) : _errors = errors;

  factory _$ImportResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportResultImplFromJson(json);

  @override
  final int totalParsed;
  @override
  final int successfullyImported;
  @override
  final int skippedDuplicates;
  final List<String> _errors;
  @override
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  final String sourceFormat;
  @override
  final DateTime importedAt;

  @override
  String toString() {
    return 'ImportResult(totalParsed: $totalParsed, successfullyImported: $successfullyImported, skippedDuplicates: $skippedDuplicates, errors: $errors, sourceFormat: $sourceFormat, importedAt: $importedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportResultImpl &&
            (identical(other.totalParsed, totalParsed) ||
                other.totalParsed == totalParsed) &&
            (identical(other.successfullyImported, successfullyImported) ||
                other.successfullyImported == successfullyImported) &&
            (identical(other.skippedDuplicates, skippedDuplicates) ||
                other.skippedDuplicates == skippedDuplicates) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.sourceFormat, sourceFormat) ||
                other.sourceFormat == sourceFormat) &&
            (identical(other.importedAt, importedAt) ||
                other.importedAt == importedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalParsed,
    successfullyImported,
    skippedDuplicates,
    const DeepCollectionEquality().hash(_errors),
    sourceFormat,
    importedAt,
  );

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      __$$ImportResultImplCopyWithImpl<_$ImportResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportResultImplToJson(this);
  }
}

abstract class _ImportResult implements ImportResult {
  const factory _ImportResult({
    required final int totalParsed,
    required final int successfullyImported,
    required final int skippedDuplicates,
    required final List<String> errors,
    required final String sourceFormat,
    required final DateTime importedAt,
  }) = _$ImportResultImpl;

  factory _ImportResult.fromJson(Map<String, dynamic> json) =
      _$ImportResultImpl.fromJson;

  @override
  int get totalParsed;
  @override
  int get successfullyImported;
  @override
  int get skippedDuplicates;
  @override
  List<String> get errors;
  @override
  String get sourceFormat;
  @override
  DateTime get importedAt;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
