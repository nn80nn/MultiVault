import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/password_strength.dart';
import '../../domain/entities/generator_config.dart';
import '../../domain/usecases/generate_password.dart';
import '../../domain/usecases/generate_passphrase.dart';
import '../../../auth/presentation/widgets/password_strength_indicator.dart';

enum GeneratorMode { random, passphrase }

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
  GeneratorMode _mode = GeneratorMode.random;

  // Random mode settings
  double _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeDigits = true;
  bool _includeSymbols = true;

  // Passphrase mode settings
  double _wordCount = 5;
  String _separator = '-';
  bool _capitalize = true;

  @override
  void initState() {
    super.initState();
    _excludedCharsController = TextEditingController();
    _generate();
  }

  @override
  void dispose() {
    _excludedCharsController.dispose();
    super.dispose();
  }

  void _generate() {
    try {
      String password;
      if (_mode == GeneratorMode.random) {
        final config = GeneratorConfig(
          length: _length.toInt(),
          uppercase: _includeUppercase,
          lowercase: _includeLowercase,
          digits: _includeDigits,
          symbols: _includeSymbols,
          excludeCharacters: _excludedCharsController.text,
        );
        password = GeneratePassword()(config);
      } else {
        password = GeneratePassphrase()(
          wordCount: _wordCount.toInt(),
          separator: _separator,
          capitalize: _capitalize,
        );
      }
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
            _buildPasswordDisplay(theme, colorScheme, strength),
            const SizedBox(height: 24),

            // Mode Toggle
            _buildModeToggle(colorScheme),
            const SizedBox(height: 16),

            // Mode-specific settings
            if (_mode == GeneratorMode.random) ...[
              _buildLengthSlider(theme, colorScheme),
              const SizedBox(height: 16),
              _buildCharacterOptions(theme, colorScheme),
              const SizedBox(height: 16),
              _buildExcludedChars(theme, colorScheme),
            ] else ...[
              _buildWordCountSlider(theme, colorScheme),
              const SizedBox(height: 16),
              _buildPassphraseOptions(theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordDisplay(ThemeData theme, ColorScheme colorScheme, PasswordStrength strength) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
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
                    ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
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
                    onPressed: _generate,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Regenerate',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle(ColorScheme colorScheme) {
    return SegmentedButton<GeneratorMode>(
      segments: const [
        ButtonSegment(
          value: GeneratorMode.random,
          label: Text('Random'),
          icon: Icon(Icons.shuffle),
        ),
        ButtonSegment(
          value: GeneratorMode.passphrase,
          label: Text('Passphrase'),
          icon: Icon(Icons.text_fields),
        ),
      ],
      selected: {_mode},
      onSelectionChanged: (selection) {
        setState(() => _mode = selection.first);
        _generate();
      },
    );
  }

  Widget _buildLengthSlider(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Length', style: theme.textTheme.titleMedium),
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
              onChanged: (value) => setState(() => _length = value),
              onChangeEnd: (value) => _generate(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterOptions(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Character Types', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildSwitch('Uppercase (A-Z)', _includeUppercase, (v) {
              setState(() => _includeUppercase = v);
              _generate();
            }),
            _buildSwitch('Lowercase (a-z)', _includeLowercase, (v) {
              setState(() => _includeLowercase = v);
              _generate();
            }),
            _buildSwitch('Digits (0-9)', _includeDigits, (v) {
              setState(() => _includeDigits = v);
              _generate();
            }),
            _buildSwitch(r'Symbols (!@#$%^&*)', _includeSymbols, (v) {
              setState(() => _includeSymbols = v);
              _generate();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExcludedChars(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Excluded Characters', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _excludedCharsController,
              decoration: const InputDecoration(
                hintText: 'Enter characters to exclude',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _generate(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCountSlider(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Word Count', style: theme.textTheme.titleMedium),
                Text(
                  _wordCount.toInt().toString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: _wordCount,
              min: 3,
              max: 10,
              divisions: 7,
              label: _wordCount.toInt().toString(),
              onChanged: (value) => setState(() => _wordCount = value),
              onChangeEnd: (value) => _generate(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassphraseOptions(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Options', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildSwitch('Capitalize words', _capitalize, (v) {
              setState(() => _capitalize = v);
              _generate();
            }),
            const SizedBox(height: 12),
            Text('Separator', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '-', label: Text('dash')),
                ButtonSegment(value: '.', label: Text('dot')),
                ButtonSegment(value: ' ', label: Text('space')),
                ButtonSegment(value: '_', label: Text('under')),
              ],
              selected: {_separator},
              onSelectionChanged: (selection) {
                setState(() => _separator = selection.first);
                _generate();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// Bottom sheet variant with "Use This Password" button
class _GeneratorBottomSheet extends StatefulWidget {
  const _GeneratorBottomSheet();

  @override
  State<_GeneratorBottomSheet> createState() => _GeneratorBottomSheetState();
}

class _GeneratorBottomSheetState extends State<_GeneratorBottomSheet> {
  String _generatedPassword = '';
  GeneratorMode _mode = GeneratorMode.random;

  // Random mode
  double _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeDigits = true;
  bool _includeSymbols = true;

  // Passphrase mode
  double _wordCount = 5;
  String _separator = '-';
  bool _capitalize = true;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    try {
      String password;
      if (_mode == GeneratorMode.random) {
        final config = GeneratorConfig(
          length: _length.toInt(),
          uppercase: _includeUppercase,
          lowercase: _includeLowercase,
          digits: _includeDigits,
          symbols: _includeSymbols,
        );
        password = GeneratePassword()(config);
      } else {
        password = GeneratePassphrase()(
          wordCount: _wordCount.toInt(),
          separator: _separator,
          capitalize: _capitalize,
        );
      }
      setState(() => _generatedPassword = password);
    } catch (e) {
      if (mounted) context.showSnackBar(e.toString(), isError: true);
      setState(() => _generatedPassword = '');
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
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Generate Password', style: theme.textTheme.titleLarge),
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
                    // Password display
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SelectableText(
                              _generatedPassword.isEmpty ? 'Generate a password' : _generatedPassword,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_generatedPassword.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              PasswordStrengthIndicator(strength: strength),
                              const SizedBox(height: 16),
                              IconButton.filled(
                                onPressed: _generate,
                                icon: const Icon(Icons.refresh),
                                tooltip: 'Regenerate',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mode toggle
                    SegmentedButton<GeneratorMode>(
                      segments: const [
                        ButtonSegment(
                          value: GeneratorMode.random,
                          label: Text('Random'),
                          icon: Icon(Icons.shuffle),
                        ),
                        ButtonSegment(
                          value: GeneratorMode.passphrase,
                          label: Text('Passphrase'),
                          icon: Icon(Icons.text_fields),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (selection) {
                        setState(() => _mode = selection.first);
                        _generate();
                      },
                    ),
                    const SizedBox(height: 16),

                    if (_mode == GeneratorMode.random) ...[
                      // Length slider
                      _buildSlider('Length', _length, 4, 128, 124, (v) {
                        setState(() => _length = v);
                      }),
                      const SizedBox(height: 12),
                      // Character toggles
                      _buildToggle('Uppercase (A-Z)', _includeUppercase, (v) {
                        setState(() => _includeUppercase = v);
                        _generate();
                      }),
                      _buildToggle('Lowercase (a-z)', _includeLowercase, (v) {
                        setState(() => _includeLowercase = v);
                        _generate();
                      }),
                      _buildToggle('Digits (0-9)', _includeDigits, (v) {
                        setState(() => _includeDigits = v);
                        _generate();
                      }),
                      _buildToggle(r'Symbols (!@#$%^&*)', _includeSymbols, (v) {
                        setState(() => _includeSymbols = v);
                        _generate();
                      }),
                    ] else ...[
                      _buildSlider('Words', _wordCount, 3, 10, 7, (v) {
                        setState(() => _wordCount = v);
                      }),
                      const SizedBox(height: 12),
                      _buildToggle('Capitalize', _capitalize, (v) {
                        setState(() => _capitalize = v);
                        _generate();
                      }),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: '-', label: Text('dash')),
                          ButtonSegment(value: '.', label: Text('dot')),
                          ButtonSegment(value: ' ', label: Text('space')),
                          ButtonSegment(value: '_', label: Text('under')),
                        ],
                        selected: {_separator},
                        onSelectionChanged: (selection) {
                          setState(() => _separator = selection.first);
                          _generate();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Use button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
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

  Widget _buildSlider(String label, double value, double min, double max, int divisions, ValueChanged<double> onChanged) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toInt().toString(),
            onChanged: onChanged,
            onChangeEnd: (_) => _generate(),
          ),
        ),
        Text(
          value.toInt().toString(),
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
