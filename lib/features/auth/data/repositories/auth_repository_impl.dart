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
    final derivedKey = _encryptionService.deriveKey(masterPassword, salt);
    final verifyHash = _encryptionService.getVerificationHash(derivedKey);
    final dbKey = _encryptionService.getDatabaseKey(derivedKey);

    await _secureStorage.setSalt(base64Encode(salt));
    await _secureStorage.setVerifyHash(verifyHash);
    await _secureStorage.setIterations(AppConstants.pbkdf2Iterations);
    await _secureStorage.setDbKey(dbKey);
    await _secureStorage.setMasterConfigured(true);
  }

  @override
  Future<Uint8List?> verifyMasterPassword(String masterPassword) async {
    final saltBase64 = await _secureStorage.getSalt();
    final storedHash = await _secureStorage.getVerifyHash();

    if (saltBase64 == null || storedHash == null) return null;

    final salt = base64Decode(saltBase64);
    final derivedKey = _encryptionService.deriveKey(masterPassword, salt);
    final computedHash = _encryptionService.getVerificationHash(derivedKey);

    if (computedHash == storedHash) {
      return derivedKey;
    }
    return null;
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
    final newKey = _encryptionService.deriveKey(newPassword, newSalt);
    final newVerifyHash = _encryptionService.getVerificationHash(newKey);
    final newDbKey = _encryptionService.getDatabaseKey(newKey);

    await _secureStorage.setSalt(base64Encode(newSalt));
    await _secureStorage.setVerifyHash(newVerifyHash);
    await _secureStorage.setDbKey(newDbKey);

    // Zero old key
    _encryptionService.zeroMemory(currentKey);
  }

  @override
  Future<void> enableBiometricKey(Uint8List encryptionKey) async {
    await _secureStorage.setBioKey(base64Encode(encryptionKey));
  }

  @override
  Future<void> disableBiometricKey() async {
    await _secureStorage.deleteBioKey();
  }

  @override
  Future<Uint8List?> getBiometricKey() async {
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
