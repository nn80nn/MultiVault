import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap.dart';
import 'core/di/providers.dart';
import 'features/auth/data/datasources/secure_storage_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final result = await bootstrap();

  // Check if master password was previously configured
  // to route to login screen instead of always showing setup
  final secureStorage = SecureStorageDatasource();
  final configured = await secureStorage.getMasterConfigured();
  final initialStatus =
      configured == 'true' ? LockStatus.locked : LockStatus.setupRequired;

  runApp(
    ProviderScope(
      overrides: [
        ...createOverrides(result),
        lockStatusProvider.overrideWith((ref) => initialStatus),
      ],
      child: const MultivaultApp(),
    ),
  );
}
