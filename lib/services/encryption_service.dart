import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' show sha256;
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';

class EncryptionService {
  /// Derives a 256-bit key from master password using PBKDF2-HMAC-SHA256
  /// Uses cryptography_flutter for native acceleration (no isolate needed)
  Future<Uint8List> deriveKey(String masterPassword, Uint8List salt) async {
    if (masterPassword.isEmpty) {
      throw ArgumentError('Master password cannot be empty');
    }
    if (salt.length != AppConstants.saltLength) {
      throw ArgumentError('Invalid salt length: expected ${AppConstants.saltLength} bytes');
    }

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: AppConstants.pbkdf2Iterations,
      bits: AppConstants.keyLength * 8,
    );

    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(masterPassword)),
      nonce: salt,
    );

    final keyBytes = await secretKey.extractBytes();
    return Uint8List.fromList(keyBytes);
  }

  /// Generates cryptographically secure random bytes
  Uint8List generateSecureRandomBytes(int length) {
    if (length <= 0 || length > 1024) {
      throw ArgumentError('Invalid length: must be between 1 and 1024 bytes');
    }
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }

  /// Generates verification hash using SHA-256 of the derived key
  /// SECURITY: Uses SHA-256 instead of taking first bytes of key to prevent key leakage
  String getVerificationHash(Uint8List derivedKey) {
    final digest = sha256.convert(derivedKey);
    return base64Encode(digest.bytes);
  }

  /// Generates a hex string from the derived key for SQLCipher PRAGMA key
  String getDatabaseKey(Uint8List derivedKey) {
    return derivedKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// AES-256-GCM encryption with authentication. Returns base64 string with nonce prepended.
  /// GCM provides both confidentiality and authenticity (AEAD - Authenticated Encryption with Associated Data)
  String encryptText(String plaintext, Uint8List key) {
    if (plaintext.isEmpty) {
      throw ArgumentError('Plaintext cannot be empty');
    }
    if (key.length != AppConstants.keyLength) {
      throw ArgumentError('Invalid key length: expected ${AppConstants.keyLength} bytes');
    }

    try {
      // GCM uses 12-byte nonce (recommended) instead of 16-byte IV
      final nonce = encrypt_lib.IV.fromSecureRandom(12);
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(encrypt_lib.Key(key), mode: encrypt_lib.AESMode.gcm),
      );
      final encrypted = encrypter.encrypt(plaintext, iv: nonce);

      // GCM output includes authentication tag (16 bytes) - handled by encrypt package
      // Format: [12-byte nonce][ciphertext + 16-byte auth tag]
      final combined = Uint8List(12 + encrypted.bytes.length);
      combined.setRange(0, 12, nonce.bytes);
      combined.setRange(12, combined.length, encrypted.bytes);
      return base64Encode(combined);
    } catch (e) {
      throw Exception('Encryption failed');
    }
  }

  /// AES-256-GCM decryption with authentication verification. Expects base64 string with nonce prepended.
  /// GCM automatically verifies authentication tag - throws if data was tampered with
  String decryptText(String encryptedBase64, Uint8List key) {
    try {
      final combined = base64Decode(encryptedBase64);

      // Validate minimum length (12-byte nonce + 16-byte auth tag + at least 1 byte plaintext)
      if (combined.length < 12 + 16 + 1) {
        throw FormatException('Invalid encrypted data: too short');
      }

      final nonce = encrypt_lib.IV(
        Uint8List.fromList(combined.sublist(0, 12)),
      );
      // Ciphertext includes authentication tag (last 16 bytes)
      final ciphertext = encrypt_lib.Encrypted(
        Uint8List.fromList(combined.sublist(12)),
      );
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(encrypt_lib.Key(key), mode: encrypt_lib.AESMode.gcm),
      );

      // GCM mode will throw if authentication tag doesn't match (data tampered)
      return encrypter.decrypt(ciphertext, iv: nonce);
    } on FormatException {
      throw FormatException('Failed to decrypt: invalid format');
    } catch (e) {
      // This catches authentication failures too
      throw Exception('Decryption failed or data was tampered with');
    }
  }

  /// Securely zeros memory buffer
  void zeroMemory(Uint8List data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = 0;
    }
  }
}
