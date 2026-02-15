import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/providers.dart';
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

  // SECURITY: Database is NOT opened here anymore
  // It will only be opened after user enters master password
  // This prevents access to encrypted data without authentication
  return BootstrapResult(prefs: prefs, database: null);
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
