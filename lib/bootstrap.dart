import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/providers.dart';
import 'features/auth/data/datasources/secure_storage_datasource.dart';
import 'features/vault/data/database/app_database.dart';
import 'services/encryption_service.dart';

class BootstrapResult {
  final SharedPreferences prefs;
  final AppDatabase? database;

  BootstrapResult({required this.prefs, this.database});
}

Future<BootstrapResult> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final secureStorage = SecureStorageDatasource();

  final configured = await secureStorage.getMasterConfigured();
  final isConfigured = configured == 'true';

  AppDatabase? database;

  if (isConfigured) {
    // DB key was stored during setup
    final dbKey = await secureStorage.getDbKey();
    if (dbKey != null) {
      database = await AppDatabase.openEncrypted(dbKey);
    }
  }

  return BootstrapResult(prefs: prefs, database: database);
}

Future<AppDatabase> openDatabaseAfterSetup(
  EncryptionService encryptionService,
  Uint8List derivedKey,
) async {
  final dbKey = encryptionService.getDatabaseKey(derivedKey);
  return AppDatabase.openEncrypted(dbKey);
}

List<Override> createOverrides(BootstrapResult result) {
  final overrides = <Override>[
    sharedPreferencesProvider.overrideWithValue(result.prefs),
  ];

  if (result.database != null) {
    overrides.add(
      appDatabaseProvider.overrideWith((ref) => result.database),
    );
  }

  return overrides;
}
