// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordHistoryImpl _$$PasswordHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$PasswordHistoryImpl(
  id: json['id'] as String,
  entryId: json['entryId'] as String,
  encryptedOldPassword: json['encryptedOldPassword'] as String,
  changedBy: json['changedBy'] as String? ?? 'user',
  changedAt: DateTime.parse(json['changedAt'] as String),
);

Map<String, dynamic> _$$PasswordHistoryImplToJson(
  _$PasswordHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'entryId': instance.entryId,
  'encryptedOldPassword': instance.encryptedOldPassword,
  'changedBy': instance.changedBy,
  'changedAt': instance.changedAt.toIso8601String(),
};
