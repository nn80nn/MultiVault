import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:pointycastle/export.dart';

import '../core/constants/app_constants.dart';

class EncryptionService {
  /// Derives a 256-bit key from master password using PBKDF2-HMAC-SHA256
  Uint8List deriveKey(String masterPassword, Uint8List salt) {
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(
        salt,
        AppConstants.pbkdf2Iterations,
        AppConstants.keyLength,
      ));
    return derivator.process(Uint8List.fromList(utf8.encode(masterPassword)));
  }

  /// Generates cryptographically secure random bytes
  Uint8List generateSecureRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
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
    final iv = encrypt_lib.IV.fromSecureRandom(AppConstants.ivLength);
    final encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(encrypt_lib.Key(key), mode: encrypt_lib.AESMode.cbc),
    );
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    final combined = Uint8List(AppConstants.ivLength + encrypted.bytes.length);
    combined.setRange(0, AppConstants.ivLength, iv.bytes);
    combined.setRange(AppConstants.ivLength, combined.length, encrypted.bytes);
    return base64Encode(combined);
  }

  /// AES-256-CBC decryption. Expects base64 string with IV prepended.
  String decryptText(String encryptedBase64, Uint8List key) {
    final combined = base64Decode(encryptedBase64);
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
  }

  /// Securely zeros memory buffer
  void zeroMemory(Uint8List data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = 0;
    }
  }
}
