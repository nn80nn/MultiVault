import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/encryption_service.dart';
import '../../domain/entities/master_password_config.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/secure_storage_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SecureStorageDatasource _secureStorage;
  final EncryptionService _encryptionService;

  AuthRepositoryImpl({
    required SecureStorageDatasource secureStorage,
    required EncryptionService encryptionService,
  })  : _secureStorage = secureStorage,
        _encryptionService = encryptionService;

  @override
  Future<bool> isMasterPasswordConfigured() async {
    final configured = await _secureStorage.getMasterConfigured();
    return configured == 'true';
  }

  @override
  Future<void> setupMasterPassword(String masterPassword) async {
    final salt = _encryptionService.generateSecureRandomBytes(AppConstants.saltLength);
    final derivedKey = await _encryptionService.deriveKey(masterPassword, salt);

    try {
      final verifyHash = _encryptionService.getVerificationHash(derivedKey);

      await _secureStorage.setSalt(base64Encode(salt));
      await _secureStorage.setVerifyHash(verifyHash);
      await _secureStorage.setIterations(AppConstants.pbkdf2Iterations);
      await _secureStorage.setMasterConfigured(true);

      // SECURITY: dbKey is NOT stored anymore. It's derived on-the-fly from master password
      // This prevents database access without password authentication
    } finally {
      // Zero out sensitive data from memory
      _encryptionService.zeroMemory(salt);
      _encryptionService.zeroMemory(derivedKey);
    }
  }

  @override
  Future<Uint8List?> verifyMasterPassword(String masterPassword) async {
    final saltBase64 = await _secureStorage.getSalt();
    final storedHash = await _secureStorage.getVerifyHash();

    if (saltBase64 == null || storedHash == null) return null;

    final salt = base64Decode(saltBase64);
    final derivedKey = await _encryptionService.deriveKey(masterPassword, salt);

    try {
      final computedHash = _encryptionService.getVerificationHash(derivedKey);

      if (computedHash == storedHash) {
        // Success - return key, caller must zero it after use
        return derivedKey;
      }

      // Failed - zero key before returning null
      _encryptionService.zeroMemory(derivedKey);
      return null;
    } finally {
      // Always zero the salt
      _encryptionService.zeroMemory(salt);
    }
  }

  @override
  Future<void> changeMasterPassword(
      String currentPassword, String newPassword) async {
    final currentKey = await verifyMasterPassword(currentPassword);
    if (currentKey == null) {
      throw Exception('Current password is incorrect');
    }

    // Generate new salt and key
    final newSalt = _encryptionService.generateSecureRandomBytes(AppConstants.saltLength);
    final newKey = await _encryptionService.deriveKey(newPassword, newSalt);

    try {
      final newVerifyHash = _encryptionService.getVerificationHash(newKey);

      await _secureStorage.setSalt(base64Encode(newSalt));
      await _secureStorage.setVerifyHash(newVerifyHash);

      // SECURITY: dbKey is NOT stored. Derived on-the-fly from password.
    } finally {
      // Zero out sensitive data from memory
      _encryptionService.zeroMemory(currentKey);
      _encryptionService.zeroMemory(newSalt);
      // Note: newKey might still be needed by caller, so don't zero it here
    }
  }

  /// SECURITY FIX: Store encryption key with mandatory biometric authentication
  ///
  /// CRITICAL: Caller MUST authenticate biometric BEFORE calling this method!
  /// This method does NOT verify authentication - it assumes caller already did.
  ///
  /// The key is stored in secure storage but without hardware-backed biometric
  /// protection due to flutter_secure_storage limitations. Application-level
  /// biometric verification is REQUIRED before this call.
  @override
  Future<void> enableBiometricKey(Uint8List encryptionKey) async {
    // SECURITY: Key is stored Base64-encoded in secure storage
    // iOS: Keychain with 'passcode' accessibility
    // Android: EncryptedSharedPreferences
    //
    // WARNING: This is NOT hardware-backed biometric protection!
    // Caller must verify biometric authentication before calling this method.
    await _secureStorage.setBioKey(base64Encode(encryptionKey));
  }

  @override
  Future<void> disableBiometricKey() async {
    await _secureStorage.deleteBioKey();
  }

  /// SECURITY FIX: Retrieve biometric-protected encryption key
  ///
  /// CRITICAL: Caller MUST authenticate biometric BEFORE calling this method!
  /// This method does NOT verify authentication - it assumes caller already did.
  ///
  /// LIMITATION: Due to flutter_secure_storage API constraints, the key is stored
  /// encrypted but NOT protected by hardware biometric validation. An attacker with
  /// device access could potentially extract the key without biometric auth.
  ///
  /// For true hardware-backed biometric security, platform channels with
  /// iOS kSecAccessControlBiometryCurrentSet or Android BiometricPrompt.CryptoObject
  /// would be required.
  @override
  Future<Uint8List?> getBiometricKey() async {
    // SECURITY: This method assumes caller already authenticated biometric!
    // Do NOT call this without BiometricService.authenticate() first.
    final keyBase64 = await _secureStorage.getBioKey();
    if (keyBase64 == null) return null;
    return base64Decode(keyBase64);
  }

  @override
  Future<MasterPasswordConfig?> getMasterPasswordConfig() async {
    final configured = await isMasterPasswordConfigured();
    if (!configured) return null;

    final saltBase64 = await _secureStorage.getSalt();
    final verifyHash = await _secureStorage.getVerifyHash();
    final iterationsStr = await _secureStorage.getIterations();

    if (saltBase64 == null || verifyHash == null) return null;

    return MasterPasswordConfig(
      passwordHash: verifyHash,
      salt: saltBase64,
      iterations: int.tryParse(iterationsStr ?? '') ?? AppConstants.pbkdf2Iterations,
      keyLength: AppConstants.keyLength,
      createdAt: DateTime.now().toUtc(),
    );
  }
}
