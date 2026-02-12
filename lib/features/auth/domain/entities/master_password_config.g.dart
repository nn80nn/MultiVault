// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_password_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MasterPasswordConfigImpl _$$MasterPasswordConfigImplFromJson(
  Map<String, dynamic> json,
) => _$MasterPasswordConfigImpl(
  passwordHash: json['passwordHash'] as String,
  salt: json['salt'] as String,
  iterations: (json['iterations'] as num).toInt(),
  keyLength: (json['keyLength'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastChangedAt: json['lastChangedAt'] == null
      ? null
      : DateTime.parse(json['lastChangedAt'] as String),
  biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$$MasterPasswordConfigImplToJson(
  _$MasterPasswordConfigImpl instance,
) => <String, dynamic>{
  'passwordHash': instance.passwordHash,
  'salt': instance.salt,
  'iterations': instance.iterations,
  'keyLength': instance.keyLength,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastChangedAt': instance.lastChangedAt?.toIso8601String(),
  'biometricsEnabled': instance.biometricsEnabled,
};
