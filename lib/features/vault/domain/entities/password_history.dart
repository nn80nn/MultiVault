import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_history.freezed.dart';
part 'password_history.g.dart';

@freezed
class PasswordHistory with _$PasswordHistory {
  const factory PasswordHistory({
    required String id,
    required String entryId,
    required String encryptedOldPassword,
    @Default('user') String changedBy,
    required DateTime changedAt,
  }) = _PasswordHistory;

  factory PasswordHistory.fromJson(Map<String, dynamic> json) =>
      _$PasswordHistoryFromJson(json);
}
