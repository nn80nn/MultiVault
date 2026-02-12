import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/password_strength.dart';
import '../../domain/entities/generator_config.dart';
import '../../domain/usecases/generate_password.dart';
import '../../../auth/presentation/widgets/password_strength_indicator.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  static Future<String?> showAsBottomSheet(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _GeneratorBottomSheet(),
    );
  }

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  late TextEditingController _excludedCharsController;
  String _generatedPassword = '';
  double _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeDigits = true;
  bool _includeSymbols = true;

  @override
  void initState() {
    super.initState();
    _excludedCharsController = TextEditingController();
    _generatePassword();
  }

  @override
  void dispose() {
    _excludedCharsController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    final config = GeneratorConfig(
      length: _length.toInt(),
      uppercase: _includeUppercase,
      lowercase: _includeLowercase,
      digits: _includeDigits,
      symbols: _includeSymbols,
      excludeCharacters: _excludedCharsController.text,
    );

    try {
      final password = GeneratePassword()(config);
      setState(() => _generatedPassword = password);
    } catch (e) {
      if (mounted) context.showSnackBar(e.toString(), isError: true);
      setState(() => _generatedPassword = '');
    }
  }

  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      context.showSnackBar('Password copied to clipboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final strength = PasswordStrengthCalculator.evaluate(_generatedPassword);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generated Password Display
            Card(
              elevation: 0,
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SelectableText(
                      _generatedPassword.isEmpty ? 'Generate a password' : _generatedPassword,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: _generatedPassword.isEmpty
                            ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                            : colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_generatedPassword.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      PasswordStrengthIndicator(strength: strength),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: _copyToClipboard,
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy'),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filled(
                            onPressed: _generatePassword,
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Regenerate',
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Password Length
            Card(
              elevation: 0,
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Length',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          _length.toInt().toString(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _length,
                      min: 4,
                      max: 128,
                      divisions: 124,
                      label: _length.toInt().toString(),
                      onChanged: (value) {
                        setState(() => _length = value);
                      },
                      onChangeEnd: (value) => _generatePassword(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Character Options
            Card(
              elevation: 0,
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Character Types',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Uppercase (A-Z)'),
                      value: _includeUppercase,
                      onChanged: (value) {
                        setState(() => _includeUppercase = value);
                        _generatePassword();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Lowercase (a-z)'),
                      value: _includeLowercase,
                      onChanged: (value) {
                        setState(() => _includeLowercase = value);
                        _generatePassword();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Digits (0-9)'),
                      value: _includeDigits,
                      onChanged: (value) {
                        setState(() => _includeDigits = value);
                        _generatePassword();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Symbols (!@#\$%^&*)'),
                      value: _includeSymbols,
                      onChanged: (value) {
                        setState(() => _includeSymbols = value);
                        _generatePassword();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Excluded Characters
            Card(
              elevation: 0,
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Excluded Characters',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _excludedCharsController,
                      decoration: const InputDecoration(
                        hintText: 'Enter characters to exclude',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => _generatePassword(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratorBottomSheet extends StatefulWidget {
  const _GeneratorBottomSheet();

  @override
  State<_GeneratorBottomSheet> createState() => _GeneratorBottomSheetState();
}

class _GeneratorBottomSheetState extends State<_GeneratorBottomSheet> {
  late TextEditingController _excludedCharsController;
  String _generatedPassword = '';
  double _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeDigits = true;
  bool _includeSymbols = true;

  @override
  void initState() {
    super.initState();
    _excludedCharsController = TextEditingController();
    _generatePassword();
  }

  @override
  void dispose() {
    _excludedCharsController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    final config = GeneratorConfig(
      length: _length.toInt(),
      uppercase: _includeUppercase,
      lowercase: _includeLowercase,
      digits: _includeDigits,
      symbols: _includeSymbols,
      excludeCharacters: _excludedCharsController.text,
    );

    try {
      final password = GeneratePassword()(config);
      setState(() => _generatedPassword = password);
    } catch (e) {
      if (mounted) context.showSnackBar(e.toString(), isError: true);
      setState(() => _generatedPassword = '');
    }
  }

  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      context.showSnackBar('Password copied to clipboard');
    }
  }

  void _usePassword() {
    if (_generatedPassword.isNotEmpty) {
      Navigator.of(context).pop(_generatedPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final strength = PasswordStrengthCalculator.evaluate(_generatedPassword);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Generate Password',
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Generated Password Display
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SelectableText(
                              _generatedPassword.isEmpty ? 'Generate a password' : _generatedPassword,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                color: _generatedPassword.isEmpty
                                    ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                                    : colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_generatedPassword.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              PasswordStrengthIndicator(strength: strength),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FilledButton.tonal(
                                    onPressed: _copyToClipboard,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.copy, size: 18),
                                        SizedBox(width: 8),
                                        Text('Copy'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton.filled(
                                    onPressed: _generatePassword,
                                    icon: const Icon(Icons.refresh),
                                    tooltip: 'Regenerate',
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Password Length
                    Card(
                      elevation: 0,
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Length',
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  _length.toInt().toString(),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _length,
                              min: 4,
                              max: 128,
                              divisions: 124,
                              label: _length.toInt().toString(),
                              onChanged: (value) {
                                setState(() => _length = value);
                              },
                              onChangeEnd: (value) => _generatePassword(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Character Options
                    Card(
                      elevation: 0,
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Character Types',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              title: const Text('Uppercase (A-Z)'),
                              value: _includeUppercase,
                              onChanged: (value) {
                                setState(() => _includeUppercase = value);
                                _generatePassword();
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text('Lowercase (a-z)'),
                              value: _includeLowercase,
                              onChanged: (value) {
                                setState(() => _includeLowercase = value);
                                _generatePassword();
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text('Digits (0-9)'),
                              value: _includeDigits,
                              onChanged: (value) {
                                setState(() => _includeDigits = value);
                                _generatePassword();
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text('Symbols (!@#\$%^&*)'),
                              value: _includeSymbols,
                              onChanged: (value) {
                                setState(() => _includeSymbols = value);
                                _generatePassword();
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Excluded Characters
                    Card(
                      elevation: 0,
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Excluded Characters',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _excludedCharsController,
                              decoration: const InputDecoration(
                                hintText: 'Enter characters to exclude',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _generatePassword(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: FilledButton(
                onPressed: _generatedPassword.isEmpty ? null : _usePassword,
                child: const Text('Use This Password'),
              ),
            ),
          ],
        );
      },
    );
  }
}
