// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordEntryImpl _$$PasswordEntryImplFromJson(Map<String, dynamic> json) =>
    _$PasswordEntryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      username: json['username'] as String,
      encryptedPassword: json['encryptedPassword'] as String,
      url: json['url'] as String?,
      encryptedNotes: json['encryptedNotes'] as String?,
      categoryId: json['categoryId'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      faviconUrl: json['faviconUrl'] as String?,
      customFields: json['customFields'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$PasswordEntryImplToJson(_$PasswordEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'username': instance.username,
      'encryptedPassword': instance.encryptedPassword,
      'url': instance.url,
      'encryptedNotes': instance.encryptedNotes,
      'categoryId': instance.categoryId,
      'isFavorite': instance.isFavorite,
      'faviconUrl': instance.faviconUrl,
      'customFields': instance.customFields,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
