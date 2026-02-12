import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/app_constants.dart';

class SecureStorageDatasource {
  final FlutterSecureStorage _storage;

  SecureStorageDatasource([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
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

  Future<String?> getBioKey() => _storage.read(key: AppConstants.ssBioKey);
  Future<void> setBioKey(String key) =>
      _storage.write(key: AppConstants.ssBioKey, value: key);
  Future<void> deleteBioKey() => _storage.delete(key: AppConstants.ssBioKey);

  Future<String?> getDbKey() => _storage.read(key: AppConstants.ssDbKey);
  Future<void> setDbKey(String key) =>
      _storage.write(key: AppConstants.ssDbKey, value: key);

  Future<String?> getMasterConfigured() =>
      _storage.read(key: AppConstants.ssMasterConfigured);
  Future<void> setMasterConfigured(bool value) => _storage.write(
      key: AppConstants.ssMasterConfigured, value: value.toString());

  Future<void> deleteAll() => _storage.deleteAll();
}
