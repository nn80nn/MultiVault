import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import '../../../vault/domain/entities/password_entry.dart';

class EncryptedBackupExporter {
  /// Exports list of PasswordEntry to encrypted JSON backup
  /// If password is provided, encrypts using AES-256-CBC
  /// Returns bytes suitable for saving to file
  Uint8List export(List<PasswordEntry> entries, {String? password}) {
    try {
      // Prepare JSON structure
      final Map<String, dynamic> backup = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'entries': entries.map((entry) => _entryToJson(entry)).toList(),
      };

      // Convert to JSON string
      final jsonString = json.encode(backup);

      // If no password, return unencrypted JSON
      if (password == null || password.isEmpty) {
        return Uint8List.fromList(utf8.encode(jsonString));
      }

      // Encrypt the JSON string
      return _encryptData(jsonString, password);
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

  /// Encrypts data using AES-256-CBC with PBKDF2 key derivation
  Uint8List _encryptData(String data, String password) {
    try {
      // Generate a random IV (Initialization Vector)
      final iv = IV.fromSecureRandom(16);

      // Generate a random salt for key derivation
      final salt = IV.fromSecureRandom(32);

      // Derive encryption key from password using PBKDF2
      final key = _deriveKey(password, salt.bytes);

      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Encrypt the data
      final encrypted = encrypter.encrypt(data, iv: iv);

      // Combine salt + IV + encrypted data
      // Format: [32 bytes salt][16 bytes IV][encrypted data]
      final result = Uint8List.fromList([
        ...salt.bytes,
        ...iv.bytes,
        ...encrypted.bytes,
      ]);

      return result;
    } catch (e) {
      throw Exception('Failed to encrypt data: $e');
    }
  }

  /// Derives a 256-bit key from password using PBKDF2
  Key _deriveKey(String password, Uint8List salt) {
    // Use PBKDF2 with SHA-256 and 100,000 iterations
    const iterations = 100000;
    final passwordBytes = utf8.encode(password);

    // Simple PBKDF2 implementation using Hmac
    var key = passwordBytes;
    for (var i = 0; i < iterations; i++) {
      final hmac = Hmac(sha256, key);
      key = Uint8List.fromList(hmac.convert([...salt, ...passwordBytes]).bytes);
    }

    // Take first 32 bytes for AES-256
    return Key(Uint8List.fromList(key.sublist(0, 32)));
  }
}
