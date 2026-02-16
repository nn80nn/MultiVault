import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../../../core/utils/password_strength.dart';
import '../../../../services/encryption_service.dart';
import '../../../vault/domain/entities/password_entry.dart';
import '../entities/password_health_result.dart';

class AnalyzePasswords {
  final EncryptionService _encryptionService;

  AnalyzePasswords(this._encryptionService);

  PasswordHealthResult analyze(
    List<PasswordEntry> entries,
    Uint8List encryptionKey,
  ) {
    final weakPasswords = <HealthIssue>[];
    final reusedPasswords = <HealthIssue>[];
    final oldPasswords = <HealthIssue>[];

    // Map password hash → list of entries with that password (for reuse detection)
    final passwordHashes = <String, List<PasswordEntry>>{};

    final now = DateTime.now().toUtc();
    final sixMonthsAgo = now.subtract(const Duration(days: 180));

    for (final entry in entries) {
      if (entry.deletedAt != null) continue;

      String decrypted;
      try {
        decrypted = _encryptionService.decryptText(
          entry.encryptedPassword,
          encryptionKey,
        );
      } catch (_) {
        continue;
      }

      // Check weak
      final strength = PasswordStrengthCalculator.evaluate(decrypted);
      if (strength == PasswordStrength.weak ||
          strength == PasswordStrength.fair) {
        weakPasswords.add(HealthIssue(
          entry: entry,
          type: HealthIssueType.weak,
          description: strength == PasswordStrength.weak
              ? 'Very weak password'
              : 'Fair but could be stronger',
        ));
      }

      // Track for reuse detection (hash to avoid storing plaintext)
      final hash = sha256.convert(utf8.encode(decrypted)).toString();
      passwordHashes.putIfAbsent(hash, () => []).add(entry);

      // Check old
      if (entry.updatedAt.isBefore(sixMonthsAgo)) {
        final months =
            now.difference(entry.updatedAt).inDays ~/ 30;
        oldPasswords.add(HealthIssue(
          entry: entry,
          type: HealthIssueType.old,
          description: 'Not changed in $months months',
        ));
      }
    }

    // Find reused passwords (same hash used by 2+ entries)
    for (final group in passwordHashes.values) {
      if (group.length > 1) {
        for (final entry in group) {
          reusedPasswords.add(HealthIssue(
            entry: entry,
            type: HealthIssueType.reused,
            description: 'Same password used by ${group.length} entries',
          ));
        }
      }
    }

    return PasswordHealthResult(
      weakPasswords: weakPasswords,
      reusedPasswords: reusedPasswords,
      oldPasswords: oldPasswords,
      totalEntries: entries.where((e) => e.deletedAt == null).length,
    );
  }
}
