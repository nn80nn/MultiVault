import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap.dart';
import 'core/di/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final result = await bootstrap();

  final initialStatus =
      result.database != null ? LockStatus.locked : LockStatus.setupRequired;

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
