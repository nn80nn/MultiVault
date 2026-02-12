// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExportConfigImpl _$$ExportConfigImplFromJson(Map<String, dynamic> json) =>
    _$ExportConfigImpl(
      format: $enumDecode(_$ExportFormatEnumMap, json['format']),
      includeHistory: json['includeHistory'] as bool? ?? true,
      encrypted: json['encrypted'] as bool? ?? true,
      exportPassword: json['exportPassword'] as String?,
    );

Map<String, dynamic> _$$ExportConfigImplToJson(_$ExportConfigImpl instance) =>
    <String, dynamic>{
      'format': _$ExportFormatEnumMap[instance.format]!,
      'includeHistory': instance.includeHistory,
      'encrypted': instance.encrypted,
      'exportPassword': instance.exportPassword,
    };

const _$ExportFormatEnumMap = {
  ExportFormat.encryptedJson: 'encryptedJson',
  ExportFormat.plainCsv: 'plainCsv',
  ExportFormat.plainJson: 'plainJson',
};
