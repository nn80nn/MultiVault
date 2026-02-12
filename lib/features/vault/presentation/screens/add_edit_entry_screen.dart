import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/input_validators.dart';
import '../../domain/entities/password_entry.dart';
import '../../domain/entities/category.dart';

class AddEditEntryScreen extends ConsumerStatefulWidget {
  final String? entryId;

  const AddEditEntryScreen({
    super.key,
    this.entryId,
  });

  @override
  ConsumerState<AddEditEntryScreen> createState() =>
      _AddEditEntryScreenState();
}

class _AddEditEntryScreenState extends ConsumerState<AddEditEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isFavorite = false;
  String? _selectedCategoryId;
  bool _isLoading = false;
  PasswordEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    if (widget.entryId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final vaultRepository = ref.read(vaultRepositoryProvider);
        final entry = await vaultRepository.getEntryById(widget.entryId!);

        if (entry != null) {
          final encryptionService = ref.read(encryptionServiceProvider);
          final key = ref.read(encryptionKeyProvider);

          String decryptedPassword = '';
          String decryptedNotes = '';

          if (key != null) {
            try {
              decryptedPassword = encryptionService.decryptText(
                entry.encryptedPassword,
                key,
              );
              if (entry.encryptedNotes != null) {
                decryptedNotes = encryptionService.decryptText(
                  entry.encryptedNotes!,
                  key,
                );
              }
            } catch (e) {
              if (mounted) {
                context.showSnackBar('Error decrypting entry data', isError: true);
              }
            }
          }

          setState(() {
            _existingEntry = entry;
            _titleController.text = entry.title;
            _usernameController.text = entry.username;
            _passwordController.text = decryptedPassword;
            _urlController.text = entry.url ?? '';
            _notesController.text = decryptedNotes;
            _isFavorite = entry.isFavorite;
            _selectedCategoryId = entry.categoryId;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            context.showSnackBar('Entry not found', isError: true);
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          context.showSnackBar('Error loading entry: $e', isError: true);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entryId != null;
    final categoryRepository = ref.watch(categoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entry' : 'Add Entry'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveEntry,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g., Gmail Account',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                      ),
                      validator: InputValidators.validateTitle,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Username
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'e.g., john.doe@gmail.com',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: InputValidators.validateUsername,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.auto_awesome),
                              onPressed: _showPasswordGenerator,
                              tooltip: 'Generate password',
                            ),
                          ],
                        ),
                      ),
                      validator: InputValidators.validatePassword,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // URL
                    TextFormField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL (optional)',
                        hintText: 'e.g., https://www.gmail.com',
                        prefixIcon: Icon(Icons.link),
                        border: OutlineInputBorder(),
                      ),
                      validator: InputValidators.validateUrl,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                        hintText: 'Add any additional notes',
                        prefixIcon: Icon(Icons.notes),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    StreamBuilder<List<Category>>(
                      stream: categoryRepository.watchAllCategories(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final categories = snapshot.data!;

                        return DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category),
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text('Select a category'),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Favorite Switch
                    Card(
                      child: SwitchListTile(
                        title: const Text('Favorite'),
                        subtitle: const Text('Mark this entry as favorite'),
                        secondary: Icon(
                          _isFavorite ? Icons.star : Icons.star_border,
                          color: _isFavorite ? context.colorScheme.primary : null,
                        ),
                        value: _isFavorite,
                        onChanged: (value) {
                          setState(() {
                            _isFavorite = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: _saveEntry,
                        icon: const Icon(Icons.save),
                        label: Text(isEditing ? 'Update Entry' : 'Save Entry'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _showPasswordGenerator() async {
    final generatedPassword = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _PasswordGeneratorBottomSheet(),
    );

    if (generatedPassword != null && generatedPassword.isNotEmpty) {
      setState(() {
        _passwordController.text = generatedPassword;
      });
    }
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final vaultRepository = ref.read(vaultRepositoryProvider);

      final now = DateTime.now();
      final entry = PasswordEntry(
        id: _existingEntry?.id ?? '',
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        encryptedPassword: _passwordController.text,
        url: _urlController.text.trim().isEmpty ? null : _urlController.text.trim(),
        encryptedNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        categoryId: _selectedCategoryId ?? 'general',
        isFavorite: _isFavorite,
        createdAt: _existingEntry?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.entryId != null) {
        await vaultRepository.updateEntry(entry);
      } else {
        await vaultRepository.createEntry(entry);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.entryId != null
                  ? 'Entry updated successfully'
                  : 'Entry created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Error saving entry: $e', isError: true);
      }
    }
  }
}

class _PasswordGeneratorBottomSheet extends StatefulWidget {
  const _PasswordGeneratorBottomSheet();

  @override
  State<_PasswordGeneratorBottomSheet> createState() =>
      _PasswordGeneratorBottomSheetState();
}

class _PasswordGeneratorBottomSheetState
    extends State<_PasswordGeneratorBottomSheet> {
  int _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (_includeUppercase) chars += uppercase;
    if (_includeLowercase) chars += lowercase;
    if (_includeNumbers) chars += numbers;
    if (_includeSymbols) chars += symbols;

    if (chars.isEmpty) {
      setState(() {
        _generatedPassword = '';
      });
      return;
    }

    final random = Random.secure();
    setState(() {
      _generatedPassword = List.generate(
        _length,
        (index) => chars[random.nextInt(chars.length)],
      ).join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Generate Password',
                  style: context.textTheme.titleLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _generatedPassword,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _generatePassword,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Length: $_length',
            style: context.textTheme.labelLarge,
          ),
          Slider(
            value: _length.toDouble(),
            min: 8,
            max: 32,
            divisions: 24,
            label: _length.toString(),
            onChanged: (value) {
              setState(() {
                _length = value.toInt();
                _generatePassword();
              });
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Uppercase (A-Z)'),
            value: _includeUppercase,
            onChanged: (value) {
              setState(() {
                _includeUppercase = value;
                _generatePassword();
              });
            },
          ),
          SwitchListTile(
            title: const Text('Lowercase (a-z)'),
            value: _includeLowercase,
            onChanged: (value) {
              setState(() {
                _includeLowercase = value;
                _generatePassword();
              });
            },
          ),
          SwitchListTile(
            title: const Text('Numbers (0-9)'),
            value: _includeNumbers,
            onChanged: (value) {
              setState(() {
                _includeNumbers = value;
                _generatePassword();
              });
            },
          ),
          SwitchListTile(
            title: const Text('Symbols (!@#\$%^&*)'),
            value: _includeSymbols,
            onChanged: (value) {
              setState(() {
                _includeSymbols = value;
                _generatePassword();
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _generatedPassword.isEmpty
                  ? null
                  : () => Navigator.of(context).pop(_generatedPassword),
              icon: const Icon(Icons.check),
              label: const Text('Use This Password'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
