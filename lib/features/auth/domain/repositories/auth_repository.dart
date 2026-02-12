import 'dart:typed_data';

import '../entities/master_password_config.dart';

abstract class AuthRepository {
  Future<bool> isMasterPasswordConfigured();
  Future<void> setupMasterPassword(String masterPassword);
  Future<Uint8List?> verifyMasterPassword(String masterPassword);
  Future<void> changeMasterPassword(
      String currentPassword, String newPassword);
  Future<void> enableBiometricKey(Uint8List encryptionKey);
  Future<void> disableBiometricKey();
  Future<Uint8List?> getBiometricKey();
  Future<MasterPasswordConfig?> getMasterPasswordConfig();
}
