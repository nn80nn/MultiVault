import 'package:freezed_annotation/freezed_annotation.dart';

part 'master_password_config.freezed.dart';
part 'master_password_config.g.dart';

@freezed
class MasterPasswordConfig with _$MasterPasswordConfig {
  const factory MasterPasswordConfig({
    required String passwordHash,
    required String salt,
    required int iterations,
    required int keyLength,
    required DateTime createdAt,
    DateTime? lastChangedAt,
    @Default(false) bool biometricsEnabled,
  }) = _MasterPasswordConfig;

  factory MasterPasswordConfig.fromJson(Map<String, dynamic> json) =>
      _$MasterPasswordConfigFromJson(json);
}
