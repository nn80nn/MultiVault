// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PasswordEntry _$PasswordEntryFromJson(Map<String, dynamic> json) {
  return _PasswordEntry.fromJson(json);
}

/// @nodoc
mixin _$PasswordEntry {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get encryptedPassword => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get encryptedNotes => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  String? get faviconUrl => throw _privateConstructorUsedError;
  String? get customFields => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this PasswordEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordEntryCopyWith<PasswordEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordEntryCopyWith<$Res> {
  factory $PasswordEntryCopyWith(
    PasswordEntry value,
    $Res Function(PasswordEntry) then,
  ) = _$PasswordEntryCopyWithImpl<$Res, PasswordEntry>;
  @useResult
  $Res call({
    String id,
    String title,
    String username,
    String encryptedPassword,
    String? url,
    String? encryptedNotes,
    String categoryId,
    bool isFavorite,
    String? faviconUrl,
    String? customFields,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$PasswordEntryCopyWithImpl<$Res, $Val extends PasswordEntry>
    implements $PasswordEntryCopyWith<$Res> {
  _$PasswordEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? username = null,
    Object? encryptedPassword = null,
    Object? url = freezed,
    Object? encryptedNotes = freezed,
    Object? categoryId = null,
    Object? isFavorite = null,
    Object? faviconUrl = freezed,
    Object? customFields = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            encryptedPassword: null == encryptedPassword
                ? _value.encryptedPassword
                : encryptedPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            encryptedNotes: freezed == encryptedNotes
                ? _value.encryptedNotes
                : encryptedNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            faviconUrl: freezed == faviconUrl
                ? _value.faviconUrl
                : faviconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            customFields: freezed == customFields
                ? _value.customFields
                : customFields // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordEntryImplCopyWith<$Res>
    implements $PasswordEntryCopyWith<$Res> {
  factory _$$PasswordEntryImplCopyWith(
    _$PasswordEntryImpl value,
    $Res Function(_$PasswordEntryImpl) then,
  ) = __$$PasswordEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String username,
    String encryptedPassword,
    String? url,
    String? encryptedNotes,
    String categoryId,
    bool isFavorite,
    String? faviconUrl,
    String? customFields,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$PasswordEntryImplCopyWithImpl<$Res>
    extends _$PasswordEntryCopyWithImpl<$Res, _$PasswordEntryImpl>
    implements _$$PasswordEntryImplCopyWith<$Res> {
  __$$PasswordEntryImplCopyWithImpl(
    _$PasswordEntryImpl _value,
    $Res Function(_$PasswordEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? username = null,
    Object? encryptedPassword = null,
    Object? url = freezed,
    Object? encryptedNotes = freezed,
    Object? categoryId = null,
    Object? isFavorite = null,
    Object? faviconUrl = freezed,
    Object? customFields = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$PasswordEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        encryptedPassword: null == encryptedPassword
            ? _value.encryptedPassword
            : encryptedPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        encryptedNotes: freezed == encryptedNotes
            ? _value.encryptedNotes
            : encryptedNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        faviconUrl: freezed == faviconUrl
            ? _value.faviconUrl
            : faviconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        customFields: freezed == customFields
            ? _value.customFields
            : customFields // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordEntryImpl implements _PasswordEntry {
  const _$PasswordEntryImpl({
    required this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    this.url,
    this.encryptedNotes,
    required this.categoryId,
    this.isFavorite = false,
    this.faviconUrl,
    this.customFields,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory _$PasswordEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String username;
  @override
  final String encryptedPassword;
  @override
  final String? url;
  @override
  final String? encryptedNotes;
  @override
  final String categoryId;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final String? faviconUrl;
  @override
  final String? customFields;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'PasswordEntry(id: $id, title: $title, username: $username, encryptedPassword: $encryptedPassword, url: $url, encryptedNotes: $encryptedNotes, categoryId: $categoryId, isFavorite: $isFavorite, faviconUrl: $faviconUrl, customFields: $customFields, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.encryptedPassword, encryptedPassword) ||
                other.encryptedPassword == encryptedPassword) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.encryptedNotes, encryptedNotes) ||
                other.encryptedNotes == encryptedNotes) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.faviconUrl, faviconUrl) ||
                other.faviconUrl == faviconUrl) &&
            (identical(other.customFields, customFields) ||
                other.customFields == customFields) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    username,
    encryptedPassword,
    url,
    encryptedNotes,
    categoryId,
    isFavorite,
    faviconUrl,
    customFields,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordEntryImplCopyWith<_$PasswordEntryImpl> get copyWith =>
      __$$PasswordEntryImplCopyWithImpl<_$PasswordEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordEntryImplToJson(this);
  }
}

abstract class _PasswordEntry implements PasswordEntry {
  const factory _PasswordEntry({
    required final String id,
    required final String title,
    required final String username,
    required final String encryptedPassword,
    final String? url,
    final String? encryptedNotes,
    required final String categoryId,
    final bool isFavorite,
    final String? faviconUrl,
    final String? customFields,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$PasswordEntryImpl;

  factory _PasswordEntry.fromJson(Map<String, dynamic> json) =
      _$PasswordEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get username;
  @override
  String get encryptedPassword;
  @override
  String? get url;
  @override
  String? get encryptedNotes;
  @override
  String get categoryId;
  @override
  bool get isFavorite;
  @override
  String? get faviconUrl;
  @override
  String? get customFields;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordEntryImplCopyWith<_$PasswordEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
