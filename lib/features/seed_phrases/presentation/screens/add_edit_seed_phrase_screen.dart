import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/seed_phrase_entry.dart';

class AddEditSeedPhraseScreen extends ConsumerStatefulWidget {
  final String? entryId;

  const AddEditSeedPhraseScreen({super.key, this.entryId});

  @override
  ConsumerState<AddEditSeedPhraseScreen> createState() =>
      _AddEditSeedPhraseScreenState();
}

class _AddEditSeedPhraseScreenState
    extends ConsumerState<AddEditSeedPhraseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phraseController = TextEditingController();
  final _blockchainController = TextEditingController();
  final _walletAddressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isPhraseVisible = false;
  bool _isLoading = false;
  SeedPhraseEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    if (widget.entryId == null) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(seedPhraseRepositoryProvider);
      final encryptionService = ref.read(encryptionServiceProvider);
      final key = ref.read(encryptionKeyProvider);
      final entry = await repository.getEntryById(widget.entryId!);

      if (entry != null && key != null) {
        final decryptedPhrase = encryptionService.decryptText(
          entry.encryptedPhrase,
          key,
        );
        String? decryptedNotes;
        if (entry.encryptedNotes != null) {
          decryptedNotes = encryptionService.decryptText(
            entry.encryptedNotes!,
            key,
          );
        }

        setState(() {
          _existingEntry = entry;
          _nameController.text = entry.name;
          _phraseController.text = decryptedPhrase;
          _blockchainController.text = entry.blockchain ?? '';
          _walletAddressController.text = entry.walletAddress ?? '';
          _notesController.text = decryptedNotes ?? '';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          context.showSnackBar('Entry not found', isError: true);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showSnackBar('Error loading entry: $e', isError: true);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phraseController.dispose();
    _blockchainController.dispose();
    _walletAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entryId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Seed Phrase' : 'Add Seed Phrase'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveEntry,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'e.g., My Bitcoin Wallet',
                        prefixIcon: Icon(Icons.label),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Blockchain
                    TextFormField(
                      controller: _blockchainController,
                      decoration: const InputDecoration(
                        labelText: 'Blockchain (optional)',
                        hintText: 'e.g., Bitcoin, Ethereum, Solana',
                        prefixIcon: Icon(Icons.currency_bitcoin),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Wallet Address
                    TextFormField(
                      controller: _walletAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Wallet Address (optional)',
                        hintText: 'e.g., 0x...',
                        prefixIcon: Icon(Icons.account_balance_wallet),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Seed Phrase
                    TextFormField(
                      controller: _phraseController,
                      obscureText: !_isPhraseVisible,
                      decoration: InputDecoration(
                        labelText: 'Seed Phrase',
                        hintText: 'Enter your seed phrase words separated by spaces',
                        prefixIcon: const Icon(Icons.key),
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPhraseVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPhraseVisible = !_isPhraseVisible;
                            });
                          },
                        ),
                      ),
                      maxLines: _isPhraseVisible ? 3 : 1,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a seed phrase';
                        }
                        if (!SeedPhraseEntry.isValidWordCount(value)) {
                          final wordCount = value.trim().split(RegExp(r'\s+')).length;
                          return 'Invalid word count ($wordCount). Must be 12, 15, 18, 21, or 24 words';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Word count helper
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _phraseController,
                      builder: (context, value, _) {
                        final words = value.text.trim().isEmpty
                            ? 0
                            : value.text.trim().split(RegExp(r'\s+')).length;
                        final isValid = const [12, 15, 18, 21, 24].contains(words);
                        return Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            '$words words${isValid ? ' (valid)' : ''}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isValid
                                  ? Colors.green
                                  : context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
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
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Warning
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.errorContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: context.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your seed phrase will be encrypted with your master password. '
                              'Never share your seed phrase with anyone.',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
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
                        label: Text(isEditing ? 'Update' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(seedPhraseRepositoryProvider);
      final now = DateTime.now();

      final entry = SeedPhraseEntry(
        id: _existingEntry?.id ?? '',
        name: _nameController.text.trim(),
        encryptedPhrase: _phraseController.text.trim(),
        blockchain: _blockchainController.text.trim().isEmpty
            ? null
            : _blockchainController.text.trim(),
        walletAddress: _walletAddressController.text.trim().isEmpty
            ? null
            : _walletAddressController.text.trim(),
        encryptedNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: _existingEntry?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.entryId != null) {
        await repository.updateEntry(entry);
      } else {
        await repository.createEntry(entry);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.entryId != null
                  ? 'Seed phrase updated'
                  : 'Seed phrase saved',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showSnackBar('Error saving: $e', isError: true);
      }
    }
  }
}
