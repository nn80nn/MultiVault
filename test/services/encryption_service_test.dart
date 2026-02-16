import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:multivault/services/encryption_service.dart';
import 'package:multivault/core/constants/app_constants.dart';

void main() {
  late EncryptionService service;

  setUp(() {
    service = EncryptionService();
  });

  group('deriveKey', () {
    test('derives a 32-byte key from password and salt', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key = await service.deriveKey('TestPassword123!', salt);

      expect(key.length, equals(AppConstants.keyLength));
    });

    test('same password and salt produce same key', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key1 = await service.deriveKey('TestPassword123!', salt);
      final key2 = await service.deriveKey('TestPassword123!', salt);

      expect(key1, equals(key2));
    });

    test('different passwords produce different keys', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key1 = await service.deriveKey('Password1!', salt);
      final key2 = await service.deriveKey('Password2!', salt);

      expect(key1, isNot(equals(key2)));
    });

    test('different salts produce different keys', () async {
      final salt1 = service.generateSecureRandomBytes(AppConstants.saltLength);
      final salt2 = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key1 = await service.deriveKey('TestPassword123!', salt1);
      final key2 = await service.deriveKey('TestPassword123!', salt2);

      expect(key1, isNot(equals(key2)));
    });

    test('throws on empty password', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      expect(
        () => service.deriveKey('', salt),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on invalid salt length', () async {
      final badSalt = Uint8List(16); // Wrong length
      expect(
        () => service.deriveKey('TestPassword123!', badSalt),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('encryptText / decryptText', () {
    late Uint8List key;

    setUp(() async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      key = await service.deriveKey('TestPassword123!', salt);
    });

    test('roundtrip: encrypt then decrypt returns original text', () {
      const plaintext = 'Hello, World! This is a secret message.';
      final encrypted = service.encryptText(plaintext, key);
      final decrypted = service.decryptText(encrypted, key);

      expect(decrypted, equals(plaintext));
    });

    test('encrypting same text twice produces different ciphertexts', () {
      const plaintext = 'Same text each time';
      final encrypted1 = service.encryptText(plaintext, key);
      final encrypted2 = service.encryptText(plaintext, key);

      // Different due to random nonce
      expect(encrypted1, isNot(equals(encrypted2)));
    });

    test('handles unicode text correctly', () {
      const plaintext = 'Привет мир! 你好世界 🔐🔑';
      final encrypted = service.encryptText(plaintext, key);
      final decrypted = service.decryptText(encrypted, key);

      expect(decrypted, equals(plaintext));
    });

    test('handles long text', () {
      final plaintext = 'A' * 10000;
      final encrypted = service.encryptText(plaintext, key);
      final decrypted = service.decryptText(encrypted, key);

      expect(decrypted, equals(plaintext));
    });

    test('throws on empty plaintext', () {
      expect(
        () => service.encryptText('', key),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on invalid key length', () {
      final badKey = Uint8List(16); // Should be 32
      expect(
        () => service.encryptText('test', badKey),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('decryption with wrong key fails (GCM auth tag)', () async {
      const plaintext = 'Secret data';
      final encrypted = service.encryptText(plaintext, key);

      final salt2 = service.generateSecureRandomBytes(AppConstants.saltLength);
      final wrongKey = await service.deriveKey('WrongPassword!', salt2);

      expect(
        () => service.decryptText(encrypted, wrongKey),
        throwsA(isA<Exception>()),
      );
    });

    test('tampered ciphertext fails GCM authentication', () {
      const plaintext = 'Tamper test';
      final encrypted = service.encryptText(plaintext, key);

      // Tamper with a byte in the middle of the ciphertext
      final bytes = base64Decode(encrypted);
      bytes[bytes.length ~/ 2] ^= 0xFF;
      final tampered = base64Encode(bytes);

      expect(
        () => service.decryptText(tampered, key),
        throwsA(isA<Exception>()),
      );
    });

    test('too-short ciphertext is rejected', () {
      // Less than 12 (nonce) + 16 (tag) + 1 (data) = 29 bytes
      final shortData = base64Encode(Uint8List(20));

      expect(
        () => service.decryptText(shortData, key),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('getVerificationHash', () {
    test('returns deterministic hash for same key', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key = await service.deriveKey('TestPassword123!', salt);

      final hash1 = service.getVerificationHash(key);
      final hash2 = service.getVerificationHash(key);

      expect(hash1, equals(hash2));
    });

    test('different keys produce different hashes', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key1 = await service.deriveKey('Password1!', salt);

      final salt2 = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key2 = await service.deriveKey('Password2!', salt2);

      final hash1 = service.getVerificationHash(key1);
      final hash2 = service.getVerificationHash(key2);

      expect(hash1, isNot(equals(hash2)));
    });

    test('hash is base64 encoded', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key = await service.deriveKey('TestPassword123!', salt);
      final hash = service.getVerificationHash(key);

      // Should be valid base64
      expect(() => base64Decode(hash), returnsNormally);
      // SHA-256 produces 32 bytes = 44 chars in base64
      expect(hash.length, equals(44));
    });
  });

  group('getDatabaseKey', () {
    test('returns hex string of correct length', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key = await service.deriveKey('TestPassword123!', salt);
      final dbKey = service.getDatabaseKey(key);

      // 32 bytes = 64 hex chars
      expect(dbKey.length, equals(64));
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(dbKey), isTrue);
    });

    test('same key produces same hex string', () async {
      final salt = service.generateSecureRandomBytes(AppConstants.saltLength);
      final key = await service.deriveKey('TestPassword123!', salt);

      expect(service.getDatabaseKey(key), equals(service.getDatabaseKey(key)));
    });
  });

  group('generateSecureRandomBytes', () {
    test('generates bytes of requested length', () {
      for (final length in [16, 32, 64, 128]) {
        final bytes = service.generateSecureRandomBytes(length);
        expect(bytes.length, equals(length));
      }
    });

    test('generates different bytes each time', () {
      final bytes1 = service.generateSecureRandomBytes(32);
      final bytes2 = service.generateSecureRandomBytes(32);

      expect(bytes1, isNot(equals(bytes2)));
    });

    test('throws on invalid length', () {
      expect(
        () => service.generateSecureRandomBytes(0),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.generateSecureRandomBytes(-1),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.generateSecureRandomBytes(1025),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('zeroMemory', () {
    test('zeroes all bytes in buffer', () {
      final data = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      service.zeroMemory(data);

      expect(data, equals(Uint8List(8)));
    });

    test('works on empty buffer', () {
      final data = Uint8List(0);
      service.zeroMemory(data); // Should not throw
      expect(data.length, equals(0));
    });
  });
}
