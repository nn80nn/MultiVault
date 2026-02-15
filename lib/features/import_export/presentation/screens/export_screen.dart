import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../vault/domain/entities/password_entry.dart' show PasswordEntry;
import '../../data/exporters/csv_exporter.dart';
import '../../data/exporters/encrypted_backup_exporter.dart';

enum ExportFormat {
  encryptedJson,
  csv,
  json,
}

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportFormat _selectedFormat = ExportFormat.encryptedJson;
  bool _includeHistory = false;
  bool _enableEncryption = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isExporting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _exportedFilePath;

  @override
  void dispose() {
    // Clear password text before disposing
    _passwordController.clear();
    _confirmPasswordController.clear();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Passwords'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Card
            Card(
              color: colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Exported files contain sensitive data. Store them securely and delete after use.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Format Selector
            Text(
              'Export Format',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<ExportFormat>(
              segments: const [
                ButtonSegment(
                  value: ExportFormat.encryptedJson,
                  label: Text('Encrypted'),
                  icon: Icon(Icons.lock),
                ),
                ButtonSegment(
                  value: ExportFormat.csv,
                  label: Text('CSV'),
                  icon: Icon(Icons.table_chart),
                ),
                ButtonSegment(
                  value: ExportFormat.json,
                  label: Text('JSON'),
                  icon: Icon(Icons.code),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (Set<ExportFormat> newSelection) {
                setState(() {
                  _selectedFormat = newSelection.first;
                  if (_selectedFormat == ExportFormat.encryptedJson) {
                    _enableEncryption = true;
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            // Options Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Options',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Include Password History'),
                      subtitle: const Text('Export previous password versions'),
                      value: _includeHistory,
                      onChanged: (value) {
                        setState(() => _includeHistory = value);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_selectedFormat != ExportFormat.encryptedJson)
                      SwitchListTile(
                        title: const Text('Enable Encryption'),
                        subtitle: const Text('Protect export with password'),
                        value: _enableEncryption,
                        onChanged: (value) {
                          setState(() => _enableEncryption = value);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Encryption Password
            if (_enableEncryption || _selectedFormat == ExportFormat.encryptedJson) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Encryption Password',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscureConfirmPassword = !_obscureConfirmPassword,
                              );
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                      ),
                      if (_passwordController.text.isNotEmpty &&
                          _confirmPasswordController.text.isNotEmpty &&
                          _passwordController.text != _confirmPasswordController.text)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Passwords do not match',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Export Info
            Card(
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'About ${_getFormatName(_selectedFormat)} Export',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getFormatDescription(_selectedFormat),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Export Button
            FilledButton.icon(
              onPressed: _canExport() ? _exportPasswords : null,
              icon: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.file_download),
              label: Text(_isExporting ? 'Exporting...' : 'Export Passwords'),
            ),
          ],
        ),
      ),
    );
  }

  bool _canExport() {
    if (_isExporting) return false;
    if (_enableEncryption || _selectedFormat == ExportFormat.encryptedJson) {
      final password = _passwordController.text;
      return password.isNotEmpty &&
          password.length >= 8 &&
          password == _confirmPasswordController.text;
    }
    return true;
  }

  Future<void> _exportPasswords() async {
    setState(() => _isExporting = true);

    // Validate export password if encryption is enabled
    if (_enableEncryption || _selectedFormat == ExportFormat.encryptedJson) {
      if (_passwordController.text.length < 8) {
        if (mounted) {
          context.showSnackBar(
            'Export password must be at least 8 characters',
            isError: true,
          );
        }
        setState(() => _isExporting = false);
        return;
      }
    }

    List<PasswordEntry>? decryptedEntries;

    try {
      final vaultRepository = ref.read(vaultRepositoryProvider);
      final encryptionService = ref.read(encryptionServiceProvider);
      final encryptionKey = ref.read(encryptionKeyProvider);

      if (encryptionKey == null) {
        if (mounted) {
          context.showSnackBar('Vault is locked', isError: true);
        }
        return;
      }

      // Get all entries
      final encryptedEntries = await vaultRepository.getAllEntriesForExport();

      // Decrypt entries in batches to minimize memory footprint
      decryptedEntries = <PasswordEntry>[];
      for (final entry in encryptedEntries) {
        try {
          final decryptedPassword = encryptionService.decryptText(
            entry.encryptedPassword,
            encryptionKey,
          );
          final decryptedNotes = entry.encryptedNotes != null
              ? encryptionService.decryptText(entry.encryptedNotes!, encryptionKey)
              : null;

          decryptedEntries.add(
            entry.copyWith(
              encryptedPassword: decryptedPassword,
              encryptedNotes: decryptedNotes,
            ),
          );
        } catch (e) {
          // Skip entries that fail to decrypt
          continue;
        }
      }

      if (decryptedEntries.isEmpty) {
        if (mounted) {
          context.showSnackBar('No entries to export', isError: true);
        }
        return;
      }

      // Generate file name and path - use cache directory for privacy
      final fileName = 'multivault_backup';
      final extension = _getFileExtension(_selectedFormat);
      final directory = await getApplicationCacheDirectory();
      final filePath = '${directory.path}/$fileName.$extension';

      // Export based on format
      switch (_selectedFormat) {
        case ExportFormat.encryptedJson:
          final bytes = EncryptedBackupExporter().export(
            decryptedEntries,
            password: _passwordController.text,
          );
          await File(filePath).writeAsBytes(bytes);
          break;
        case ExportFormat.csv:
          final csvContent = CsvExporter().export(decryptedEntries);
          await File(filePath).writeAsString(csvContent);
          break;
        case ExportFormat.json:
          final bytes = EncryptedBackupExporter().export(
            decryptedEntries,
            password: _enableEncryption ? _passwordController.text : null,
          );
          await File(filePath).writeAsBytes(bytes);
          break;
      }

      _exportedFilePath = filePath;

      final exportedCount = decryptedEntries.length;
      if (mounted) {
        await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            title: const Text('Export Successful'),
            content: Text(
              'Exported $exportedCount passwords',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _shareExportFile();
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Don't expose sensitive error details
      if (mounted) {
        context.showSnackBar('Export failed. Please try again.', isError: true);
      }
    } finally {
      // Clean up decrypted data from memory
      if (decryptedEntries != null) {
        decryptedEntries.clear();
        decryptedEntries = null;
      }

      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _shareExportFile() async {
    if (_exportedFilePath == null) return;
    try {
      await Share.shareXFiles([XFile(_exportedFilePath!)]);
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Share failed: $e', isError: true);
      }
    }
  }

  String _getFormatName(ExportFormat format) {
    switch (format) {
      case ExportFormat.encryptedJson:
        return 'Encrypted JSON';
      case ExportFormat.csv:
        return 'CSV';
      case ExportFormat.json:
        return 'JSON';
    }
  }

  String _getFileExtension(ExportFormat format) {
    switch (format) {
      case ExportFormat.encryptedJson:
        return 'json.enc';
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.json:
        return 'json';
    }
  }

  String _getFormatDescription(ExportFormat format) {
    switch (format) {
      case ExportFormat.encryptedJson:
        return 'Exports your passwords in an encrypted JSON format. This is the most secure option and can be re-imported into MultiVault.';
      case ExportFormat.csv:
        return 'Exports your passwords in CSV format, compatible with most password managers and spreadsheet applications. Can be encrypted with a password.';
      case ExportFormat.json:
        return 'Exports your passwords in plain JSON format. This format is readable and can be imported into other applications. Can be encrypted with a password.';
    }
  }
}
