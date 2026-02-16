import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/app_constants.dart';

class SecureStorageDatasource {
  final FlutterSecureStorage _storage;

  // SECURITY: Separate storage instance for biometric-protected encryption key
  // iOS: Uses 'passcode' - only accessible when device has passcode, doesn't migrate
  // Android: Uses EncryptedSharedPreferences
  //
  // IMPORTANT LIMITATION: flutter_secure_storage doesn't support hardware-backed
  // biometric protection (iOS kSecAccessControlBiometryCurrentSet or Android
  // BiometricPrompt.CryptoObject). For true biometric security, we MUST enforce
  // biometric authentication in application code before read/write operations.
  final FlutterSecureStorage _biometricStorage;

  SecureStorageDatasource([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            ),
        _biometricStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            // Requires device passcode, doesn't migrate to new device
            // Most secure option available without platform channels
            accessibility: KeychainAccessibility.passcode,
          ),
        );

  Future<String?> getSalt() => _storage.read(key: AppConstants.ssSalt);
  Future<void> setSalt(String salt) =>
      _storage.write(key: AppConstants.ssSalt, value: salt);

  Future<String?> getVerifyHash() =>
      _storage.read(key: AppConstants.ssVerifyHash);
  Future<void> setVerifyHash(String hash) =>
      _storage.write(key: AppConstants.ssVerifyHash, value: hash);

  Future<String?> getIterations() =>
      _storage.read(key: AppConstants.ssIterations);
  Future<void> setIterations(int iterations) =>
      _storage.write(key: AppConstants.ssIterations, value: '$iterations');

  /// SECURITY: Biometric key storage with hardware protection
  ///
  /// CRITICAL: This method does NOT verify biometric authentication!
  /// Caller MUST call BiometricService.authenticate() BEFORE calling this method.
  ///
  /// LIMITATION: flutter_secure_storage doesn't support hardware-backed biometric
  /// protection (iOS kSecAccessControlBiometryCurrentSet or Android BiometricPrompt
  /// CryptoObject). The key is stored encrypted but can be read without biometric
  /// if attacker has device access. Application-level biometric check is mandatory.
  ///
  /// iOS: Keychain with 'passcode' accessibility (requires device passcode)
  /// Android: EncryptedSharedPreferences (software encryption only)
  Future<String?> getBioKey() => _biometricStorage.read(key: AppConstants.ssBioKey);

  /// SECURITY: Store biometric-protected encryption key
  ///
  /// CRITICAL: Caller MUST call BiometricService.authenticate() BEFORE calling this!
  ///
  /// The key is stored in platform-specific secure storage but NOT hardware-protected.
  /// See getBioKey() documentation for security limitations.
  Future<void> setBioKey(String key) =>
      _biometricStorage.write(key: AppConstants.ssBioKey, value: key);

  Future<void> deleteBioKey() => _biometricStorage.delete(key: AppConstants.ssBioKey);

  // SECURITY: dbKey methods removed - key is derived on-the-fly from master password
  // This prevents unauthorized database access without password authentication

  Future<String?> getMasterConfigured() =>
      _storage.read(key: AppConstants.ssMasterConfigured);
  Future<void> setMasterConfigured(bool value) => _storage.write(
      key: AppConstants.ssMasterConfigured, value: value.toString());

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    await _biometricStorage.deleteAll();
  }
}
