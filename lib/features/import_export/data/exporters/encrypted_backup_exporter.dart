import 'dart:convert';
import 'dart:typed_data';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/encryption_service.dart';
import '../../../vault/domain/entities/password_entry.dart';

class EncryptedBackupExporter {
  final EncryptionService _encryptionService;

  EncryptedBackupExporter(this._encryptionService);

  /// Exports list of PasswordEntry to encrypted JSON backup
  /// Encrypts using AES-256-GCM with PBKDF2 key derivation
  /// SECURITY: ALWAYS requires password - no unencrypted exports
  /// Returns bytes suitable for saving to file
  Future<Uint8List> export(List<PasswordEntry> entries, {String? password}) async {
    // SECURITY: fail-closed - never allow unencrypted export
    if (password == null || password.isEmpty) {
      throw ArgumentError(
        'Password is required for encrypted export. '
        'Use JSON format without encryption if you want unencrypted export.',
      );
    }

    try {
      // Prepare JSON structure
      final Map<String, dynamic> backup = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'entries': entries.map((entry) => _entryToJson(entry)).toList(),
      };

      // Convert to JSON string
      final jsonString = json.encode(backup);

      // Encrypt the JSON string
      return await _encryptData(jsonString, password);
    } catch (e) {
      throw Exception('Failed to export encrypted backup: $e');
    }
  }

  /// Converts PasswordEntry to JSON map
  Map<String, dynamic> _entryToJson(PasswordEntry entry) {
    return {
      'id': entry.id,
      'title': entry.title,
      'username': entry.username,
      'encryptedPassword': entry.encryptedPassword,
      'url': entry.url,
      'encryptedNotes': entry.encryptedNotes,
      'categoryId': entry.categoryId,
      'isFavorite': entry.isFavorite,
      'faviconUrl': entry.faviconUrl,
      'customFields': entry.customFields,
      'createdAt': entry.createdAt.toIso8601String(),
      'updatedAt': entry.updatedAt.toIso8601String(),
      'deletedAt': entry.deletedAt?.toIso8601String(),
    };
  }

  /// Encrypts data using AES-256-GCM with PBKDF2 key derivation
  /// Uses same encryption service as the main app for consistency
  Future<Uint8List> _encryptData(String data, String password) async {
    Uint8List? salt;
    Uint8List? derivedKey;

    try {
      // Generate a random salt for key derivation
      salt = _encryptionService.generateSecureRandomBytes(AppConstants.saltLength);

      // Derive encryption key from password using PBKDF2 (async - runs in isolate)
      derivedKey = await _encryptionService.deriveKey(password, salt);

      // Encrypt using AES-256-GCM
      final encryptedBase64 = _encryptionService.encryptText(data, derivedKey);
      final encryptedBytes = base64.decode(encryptedBase64);

      // Combine salt + encrypted data
      // Format: [32 bytes salt][12-byte nonce + ciphertext + 16-byte auth tag]
      final result = Uint8List.fromList([
        ...salt,
        ...encryptedBytes,
      ]);

      return result;
    } catch (e) {
      throw Exception('Failed to encrypt data: $e');
    } finally {
      // Zero out sensitive data from memory
      if (salt != null) {
        _encryptionService.zeroMemory(salt);
      }
      if (derivedKey != null) {
        _encryptionService.zeroMemory(derivedKey);
      }
    }
  }
}
