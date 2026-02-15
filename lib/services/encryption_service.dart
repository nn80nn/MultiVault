import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';

class _DeriveKeyParams {
  final String masterPassword;
  final Uint8List salt;
  final int iterations;
  final int keyLength;

  _DeriveKeyParams({
    required this.masterPassword,
    required this.salt,
    required this.iterations,
    required this.keyLength,
  });
}

Future<Uint8List> _deriveKeyInIsolate(_DeriveKeyParams params) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: params.iterations,
    bits: params.keyLength * 8,
  );

  final secretKey = await pbkdf2.deriveKey(
    secretKey: SecretKey(utf8.encode(params.masterPassword)),
    nonce: params.salt,
  );

  final keyBytes = await secretKey.extractBytes();
  return Uint8List.fromList(keyBytes);
}

class EncryptionService {
  /// Derives a 256-bit key from master password using PBKDF2-HMAC-SHA256
  /// Runs in a separate isolate to avoid blocking the UI thread
  Future<Uint8List> deriveKey(String masterPassword, Uint8List salt) async {
    if (masterPassword.isEmpty) {
      throw ArgumentError('Master password cannot be empty');
    }
    if (salt.length != AppConstants.saltLength) {
      throw ArgumentError('Invalid salt length: expected ${AppConstants.saltLength} bytes');
    }

    return compute(
      _deriveKeyInIsolate,
      _DeriveKeyParams(
        masterPassword: masterPassword,
        salt: salt,
        iterations: AppConstants.pbkdf2Iterations,
        keyLength: AppConstants.keyLength,
      ),
    );
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

  /// Extracts verification hash (first 16 bytes of derived key) as base64
  String getVerificationHash(Uint8List derivedKey) {
    return base64Encode(derivedKey.sublist(0, 16));
  }

  /// Generates a hex string from the derived key for SQLCipher PRAGMA key
  String getDatabaseKey(Uint8List derivedKey) {
    return derivedKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// AES-256-CBC encryption. Returns base64 string with IV prepended.
  String encryptText(String plaintext, Uint8List key) {
    if (plaintext.isEmpty) {
      throw ArgumentError('Plaintext cannot be empty');
    }
    if (key.length != AppConstants.keyLength) {
      throw ArgumentError('Invalid key length: expected ${AppConstants.keyLength} bytes');
    }

    try {
      final iv = encrypt_lib.IV.fromSecureRandom(AppConstants.ivLength);
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(encrypt_lib.Key(key), mode: encrypt_lib.AESMode.cbc),
      );
      final encrypted = encrypter.encrypt(plaintext, iv: iv);

      final combined = Uint8List(AppConstants.ivLength + encrypted.bytes.length);
      combined.setRange(0, AppConstants.ivLength, iv.bytes);
      combined.setRange(AppConstants.ivLength, combined.length, encrypted.bytes);
      return base64Encode(combined);
    } catch (e) {
      throw Exception('Encryption failed');
    }
  }

  /// AES-256-CBC decryption. Expects base64 string with IV prepended.
  String decryptText(String encryptedBase64, Uint8List key) {
    try {
      final combined = base64Decode(encryptedBase64);

      // Validate minimum length (IV + at least one block)
      if (combined.length < AppConstants.ivLength + 16) {
        throw FormatException('Invalid encrypted data: too short');
      }

      final iv = encrypt_lib.IV(
        Uint8List.fromList(combined.sublist(0, AppConstants.ivLength)),
      );
      final ciphertext = encrypt_lib.Encrypted(
        Uint8List.fromList(combined.sublist(AppConstants.ivLength)),
      );
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(encrypt_lib.Key(key), mode: encrypt_lib.AESMode.cbc),
      );
      return encrypter.decrypt(ciphertext, iv: iv);
    } on FormatException {
      throw FormatException('Failed to decrypt: invalid format');
    } catch (e) {
      throw Exception('Decryption failed');
    }
  }

  /// Securely zeros memory buffer
  void zeroMemory(Uint8List data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = 0;
    }
  }
}
