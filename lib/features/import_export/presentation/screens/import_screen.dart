import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/extensions/context_extensions.dart';

enum ImportFormat {
  chromeCSV,
  firefoxCSV,
  lastPassCSV,
  keepassXML,
  json,
}

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  ImportFormat _selectedFormat = ImportFormat.chromeCSV;
  PlatformFile? _selectedFile;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Passwords'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Import passwords from other password managers or browsers',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
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
              'Select Format',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<ImportFormat>(
              segments: const [
                ButtonSegment(
                  value: ImportFormat.chromeCSV,
                  label: Text('Chrome'),
                  icon: Icon(Icons.chrome_reader_mode),
                ),
                ButtonSegment(
                  value: ImportFormat.firefoxCSV,
                  label: Text('Firefox'),
                  icon: Icon(Icons.web),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (Set<ImportFormat> newSelection) {
                setState(() {
                  _selectedFormat = newSelection.first;
                  _selectedFile = null;
                });
              },
            ),
            const SizedBox(height: 12),
            SegmentedButton<ImportFormat>(
              segments: const [
                ButtonSegment(
                  value: ImportFormat.lastPassCSV,
                  label: Text('LastPass'),
                  icon: Icon(Icons.vpn_key),
                ),
                ButtonSegment(
                  value: ImportFormat.keepassXML,
                  label: Text('KeePass'),
                  icon: Icon(Icons.lock),
                ),
                ButtonSegment(
                  value: ImportFormat.json,
                  label: Text('JSON'),
                  icon: Icon(Icons.code),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (Set<ImportFormat> newSelection) {
                setState(() {
                  _selectedFormat = newSelection.first;
                  _selectedFile = null;
                });
              },
            ),
            const SizedBox(height: 24),

            // File Selector
            Text(
              'Select File',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: _selectedFile == null
                  ? InkWell(
                      onTap: _pickFile,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.upload_file,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select File',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to browse files',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 48,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedFile!.name,
                                      style: theme.textTheme.titleMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatFileSize(_selectedFile!.size),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => _selectedFile = null);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: _pickFile,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Change File'),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Import Instructions
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
                          Icons.help_outline,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'How to export from ${_getFormatName(_selectedFormat)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getInstructions(_selectedFormat),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Import Button
            FilledButton.icon(
              onPressed: _selectedFile == null || _isImporting ? null : _importFile,
              icon: _isImporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.file_download),
              label: Text(_isImporting ? 'Importing...' : 'Import Passwords'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _getAllowedExtensions(_selectedFormat),
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to pick file: $e', isError: true);
      }
    }
  }

  Future<void> _importFile() async {
    if (_selectedFile == null) return;

    setState(() => _isImporting = true);

    try {
      // Simulate import process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final imported = 42; // Mock count
        final skipped = 3; // Mock count

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, size: 64, color: Colors.green),
            title: const Text('Import Successful'),
            content: Text(
              'Imported $imported passwords\n'
              'Skipped $skipped duplicates',
              textAlign: TextAlign.center,
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Import failed: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  List<String> _getAllowedExtensions(ImportFormat format) {
    switch (format) {
      case ImportFormat.chromeCSV:
      case ImportFormat.firefoxCSV:
      case ImportFormat.lastPassCSV:
        return ['csv'];
      case ImportFormat.keepassXML:
        return ['xml', 'kdbx'];
      case ImportFormat.json:
        return ['json'];
    }
  }

  String _getFormatName(ImportFormat format) {
    switch (format) {
      case ImportFormat.chromeCSV:
        return 'Chrome';
      case ImportFormat.firefoxCSV:
        return 'Firefox';
      case ImportFormat.lastPassCSV:
        return 'LastPass';
      case ImportFormat.keepassXML:
        return 'KeePass';
      case ImportFormat.json:
        return 'JSON';
    }
  }

  String _getInstructions(ImportFormat format) {
    switch (format) {
      case ImportFormat.chromeCSV:
        return '1. Open Chrome and go to chrome://password-manager/settings\n'
            '2. Click "Export passwords"\n'
            '3. Save the CSV file and import it here';
      case ImportFormat.firefoxCSV:
        return '1. Open Firefox and go to about:logins\n'
            '2. Click the three dots menu and select "Export Logins"\n'
            '3. Save the CSV file and import it here';
      case ImportFormat.lastPassCSV:
        return '1. Log in to LastPass\n'
            '2. Go to Account Options > Advanced > Export\n'
            '3. Save the CSV file and import it here';
      case ImportFormat.keepassXML:
        return '1. Open your KeePass database\n'
            '2. Go to File > Export\n'
            '3. Choose XML or KDBX format and save';
      case ImportFormat.json:
        return 'Import passwords from a JSON file exported from MultiVault';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
