import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';

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

  @override
  void dispose() {
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
      return _passwordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    }
    return true;
  }

  Future<void> _exportPasswords() async {
    setState(() => _isExporting = true);

    try {
      // Simulate export process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final fileName = 'multivault_export_${DateTime.now().millisecondsSinceEpoch}';
        final extension = _getFileExtension(_selectedFormat);

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, size: 64, color: Colors.green),
            title: const Text('Export Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your passwords have been exported to:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$fileName.$extension',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'The file has been saved to your Downloads folder.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
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
      if (mounted) {
        context.showSnackBar('Export failed: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _shareExportFile() async {
    // In a real implementation, this would use share_plus package
    context.showSnackBar('Share functionality not implemented in this demo');
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
