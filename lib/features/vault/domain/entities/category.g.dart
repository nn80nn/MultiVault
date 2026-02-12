// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String? ?? 'folder',
      colorValue: (json['colorValue'] as num).toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
