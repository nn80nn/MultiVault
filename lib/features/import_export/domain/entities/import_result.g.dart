// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImportResultImpl _$$ImportResultImplFromJson(Map<String, dynamic> json) =>
    _$ImportResultImpl(
      totalParsed: (json['totalParsed'] as num).toInt(),
      successfullyImported: (json['successfullyImported'] as num).toInt(),
      skippedDuplicates: (json['skippedDuplicates'] as num).toInt(),
      errors: (json['errors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sourceFormat: json['sourceFormat'] as String,
      importedAt: DateTime.parse(json['importedAt'] as String),
    );

Map<String, dynamic> _$$ImportResultImplToJson(_$ImportResultImpl instance) =>
    <String, dynamic>{
      'totalParsed': instance.totalParsed,
      'successfullyImported': instance.successfullyImported,
      'skippedDuplicates': instance.skippedDuplicates,
      'errors': instance.errors,
      'sourceFormat': instance.sourceFormat,
      'importedAt': instance.importedAt.toIso8601String(),
    };
