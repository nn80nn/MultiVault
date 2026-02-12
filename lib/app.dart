import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/auto_lock_service.dart';

class MultivaultApp extends ConsumerStatefulWidget {
  const MultivaultApp({super.key});

  @override
  ConsumerState<MultivaultApp> createState() => _MultivaultAppState();
}

class _MultivaultAppState extends ConsumerState<MultivaultApp>
    with WidgetsBindingObserver {
  AutoLockService? _autoLockService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoLockService?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      final lockStatus = ref.read(lockStatusProvider);
      if (lockStatus == LockStatus.unlocked) {
        _autoLockService?.onAppBackgrounded();
      }
    }
    if (state == AppLifecycleState.resumed) {
      _autoLockService?.resetTimer();
    }
  }

  void _initAutoLock() {
    _autoLockService?.dispose();
    final settings = ref.read(appSettingsProvider).valueOrNull;
    final timeout = settings?.autoLockTimeoutSeconds ?? 300;

    _autoLockService = AutoLockService(
      timeoutSeconds: timeout,
      onLock: () {
        final key = ref.read(encryptionKeyProvider);
        if (key != null) {
          ref.read(encryptionServiceProvider).zeroMemory(key);
        }
        ref.read(encryptionKeyProvider.notifier).state = null;
        ref.read(lockStatusProvider.notifier).state = LockStatus.locked;
      },
    );
    _autoLockService!.resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final lockStatus = ref.watch(lockStatusProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final themeMode = settingsAsync.valueOrNull?.themeMode ?? ThemeMode.system;

    // Init auto-lock when unlocked
    if (lockStatus == LockStatus.unlocked) {
      _initAutoLock();
    }

    return Listener(
      onPointerDown: (_) => _autoLockService?.resetTimer(),
      child: MaterialApp.router(
        title: 'Multivault',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}
