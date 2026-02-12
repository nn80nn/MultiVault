// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeneratorConfigImpl _$$GeneratorConfigImplFromJson(
  Map<String, dynamic> json,
) => _$GeneratorConfigImpl(
  length: (json['length'] as num?)?.toInt() ?? 16,
  uppercase: json['uppercase'] as bool? ?? true,
  lowercase: json['lowercase'] as bool? ?? true,
  digits: json['digits'] as bool? ?? true,
  symbols: json['symbols'] as bool? ?? true,
  excludeCharacters: json['excludeCharacters'] as String? ?? '',
);

Map<String, dynamic> _$$GeneratorConfigImplToJson(
  _$GeneratorConfigImpl instance,
) => <String, dynamic>{
  'length': instance.length,
  'uppercase': instance.uppercase,
  'lowercase': instance.lowercase,
  'digits': instance.digits,
  'symbols': instance.symbols,
  'excludeCharacters': instance.excludeCharacters,
};
