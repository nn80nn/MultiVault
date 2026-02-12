import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/secure_storage_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/breach_check/data/datasources/hibp_api_datasource.dart';
import '../../features/breach_check/data/repositories/breach_check_repository_impl.dart';
import '../../features/breach_check/domain/entities/breach_result.dart';
import '../../features/breach_check/domain/repositories/breach_check_repository.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/entities/app_settings.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/vault/data/database/app_database.dart';
import '../../features/vault/data/repositories/category_repository_impl.dart';
import '../../features/vault/data/repositories/vault_repository_impl.dart';
import '../../features/vault/domain/repositories/category_repository.dart';
import '../../features/vault/domain/repositories/vault_repository.dart';
import '../../services/biometric_service.dart';
import '../../services/clipboard_service.dart';
import '../../services/encryption_service.dart';

// Lock state
enum LockStatus { locked, unlocked, setupRequired }

final lockStatusProvider = StateProvider<LockStatus>((ref) => LockStatus.locked);

// Encryption key in memory (null when locked)
final encryptionKeyProvider = StateProvider<Uint8List?>((ref) => null);

// Services
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService();
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

final clipboardServiceProvider = Provider<ClipboardService>((ref) {
  return ClipboardService();
});

final secureStorageDatasourceProvider =
    Provider<SecureStorageDatasource>((ref) {
  return SecureStorageDatasource();
});

// Database (StateProvider so setup flow can set it at runtime)
final appDatabaseProvider = StateProvider<AppDatabase?>((ref) => null);

// SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    secureStorage: ref.watch(secureStorageDatasourceProvider),
    encryptionService: ref.watch(encryptionServiceProvider),
  );
});

final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  if (db == null) throw StateError('Database not initialized');
  return VaultRepositoryImpl(
    entryDao: db.passwordEntryDao,
    historyDao: db.passwordHistoryDao,
    encryptionService: ref.watch(encryptionServiceProvider),
    getEncryptionKey: () {
      final key = ref.read(encryptionKeyProvider);
      if (key == null) throw StateError('App is locked');
      return key;
    },
  );
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  if (db == null) throw StateError('Database not initialized');
  return CategoryRepositoryImpl(categoryDao: db.categoryDao);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

final breachCheckRepositoryProvider = Provider<BreachCheckRepository>((ref) {
  return BreachCheckRepositoryImpl(datasource: HibpApiDatasource());
});

// Settings state
final appSettingsProvider =
    StreamProvider<AppSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

// Breach check
final breachCheckProvider =
    FutureProvider.family<BreachResult, String>((ref, password) {
  return ref.watch(breachCheckRepositoryProvider).checkPassword(password);
});
