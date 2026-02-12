import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            // Security Section
            _buildSectionHeader(context, 'Security'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset),
                    title: const Text('Change Master Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showChangeMasterPasswordDialog(context, ref),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint),
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('Use fingerprint or face recognition'),
                    value: settings.biometricsEnabled,
                    onChanged: (value) async {
                      final updatedSettings = settings.copyWith(biometricsEnabled: value);
                      await ref
                          .read(settingsRepositoryProvider)
                          .saveSettings(updatedSettings);
                      if (context.mounted) {
                        context.showSnackBar(
                          value ? 'Biometrics enabled' : 'Biometrics disabled',
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text('Auto-lock Timeout'),
                    subtitle: Text(_getAutoLockText(settings.autoLockTimeoutSeconds)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAutoLockDialog(context, ref, settings),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.content_paste),
                    title: const Text('Clipboard Clear Duration'),
                    subtitle: Text(_getClipboardClearText(settings.clipboardClearSeconds)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showClipboardClearDialog(context, ref, settings),
                  ),
                ],
              ),
            ),

            // Appearance Section
            _buildSectionHeader(context, 'Appearance'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: Text(_getThemeText(settings.themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context, ref, settings),
              ),
            ),

            // Data Section
            _buildSectionHeader(context, 'Data'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_upload),
                    title: const Text('Import Passwords'),
                    subtitle: const Text('Import from other password managers'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/import'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download),
                    title: const Text('Export / Backup'),
                    subtitle: const Text('Export your passwords'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/export'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.security),
                    title: const Text('Breach Check'),
                    subtitle: const Text('Check passwords against known breaches'),
                    value: settings.breachCheckEnabled,
                    onChanged: (value) async {
                      final updatedSettings = settings.copyWith(breachCheckEnabled: value);
                      await ref
                          .read(settingsRepositoryProvider)
                          .saveSettings(updatedSettings);
                      if (context.mounted) {
                        context.showSnackBar(
                          value ? 'Breach check enabled' : 'Breach check disabled',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // About Section
            _buildSectionHeader(context, 'About'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                    trailing: const Text('Build 1'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.article),
                    title: const Text('Licenses'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'MultiVault',
                        applicationVersion: '1.0.0',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  String _getAutoLockText(int seconds) {
    if (seconds == 0) return 'Never';
    if (seconds < 60) return '$seconds seconds';
    final minutes = seconds ~/ 60;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  String _getClipboardClearText(int seconds) {
    if (seconds == 0) return 'Never';
    if (seconds < 60) return '$seconds seconds';
    final minutes = seconds ~/ 60;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  String _getThemeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  Future<void> _showChangeMasterPasswordDialog(BuildContext context, WidgetRef ref) async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Master Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Change'),
          ),
        ],
      ),
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (result == true && context.mounted) {
      context.showSnackBar('Master password changed successfully');
    }
  }

  Future<void> _showAutoLockDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic settings,
  ) async {
    final currentTimeout = settings.autoLockTimeoutSeconds as int;
    final options = [
      (0, 'Never'),
      (30, '30 seconds'),
      (60, '1 minute'),
      (300, '5 minutes'),
      (600, '10 minutes'),
      (1800, '30 minutes'),
    ];

    final result = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Auto-lock Timeout'),
        children: options.map((option) {
          return RadioListTile<int>(
            title: Text(option.$2),
            value: option.$1,
            groupValue: currentTimeout,
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
          );
        }).toList(),
      ),
    );

    if (result != null) {
      final updatedSettings = settings.copyWith(autoLockTimeoutSeconds: result);
      await ref.read(settingsRepositoryProvider).saveSettings(updatedSettings);
      if (context.mounted) {
        context.showSnackBar('Auto-lock timeout updated');
      }
    }
  }

  Future<void> _showClipboardClearDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic settings,
  ) async {
    final currentDuration = settings.clipboardClearSeconds as int;
    final options = [
      (0, 'Never'),
      (30, '30 seconds'),
      (60, '1 minute'),
      (120, '2 minutes'),
      (300, '5 minutes'),
    ];

    final result = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Clipboard Clear Duration'),
        children: options.map((option) {
          return RadioListTile<int>(
            title: Text(option.$2),
            value: option.$1,
            groupValue: currentDuration,
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
          );
        }).toList(),
      ),
    );

    if (result != null) {
      final updatedSettings = settings.copyWith(clipboardClearSeconds: result);
      await ref.read(settingsRepositoryProvider).saveSettings(updatedSettings);
      if (context.mounted) {
        context.showSnackBar('Clipboard clear duration updated');
      }
    }
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic settings,
  ) async {
    final currentTheme = settings.themeMode as ThemeMode;
    final options = [
      (ThemeMode.system, 'System', Icons.settings),
      (ThemeMode.light, 'Light', Icons.light_mode),
      (ThemeMode.dark, 'Dark', Icons.dark_mode),
    ];

    final result = await showDialog<ThemeMode>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Theme'),
        children: options.map((option) {
          return RadioListTile<ThemeMode>(
            secondary: Icon(option.$3),
            title: Text(option.$2),
            value: option.$1,
            groupValue: currentTheme,
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
          );
        }).toList(),
      ),
    );

    if (result != null) {
      final updatedSettings = settings.copyWith(themeMode: result);
      await ref.read(settingsRepositoryProvider).saveSettings(updatedSettings);
      if (context.mounted) {
        context.showSnackBar('Theme updated');
      }
    }
  }
}
