// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breach_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreachResultImpl _$$BreachResultImplFromJson(Map<String, dynamic> json) =>
    _$BreachResultImpl(
      isBreached: json['isBreached'] as bool,
      occurrenceCount: (json['occurrenceCount'] as num).toInt(),
      checkedAt: DateTime.parse(json['checkedAt'] as String),
    );

Map<String, dynamic> _$$BreachResultImplToJson(_$BreachResultImpl instance) =>
    <String, dynamic>{
      'isBreached': instance.isBreached,
      'occurrenceCount': instance.occurrenceCount,
      'checkedAt': instance.checkedAt.toIso8601String(),
    };
