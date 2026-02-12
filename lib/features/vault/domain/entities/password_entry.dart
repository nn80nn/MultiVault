import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_entry.freezed.dart';
part 'password_entry.g.dart';

@freezed
class PasswordEntry with _$PasswordEntry {
  const factory PasswordEntry({
    required String id,
    required String title,
    required String username,
    required String encryptedPassword,
    String? url,
    String? encryptedNotes,
    required String categoryId,
    @Default(false) bool isFavorite,
    String? faviconUrl,
    String? customFields,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _PasswordEntry;

  factory PasswordEntry.fromJson(Map<String, dynamic> json) =>
      _$PasswordEntryFromJson(json);
}
