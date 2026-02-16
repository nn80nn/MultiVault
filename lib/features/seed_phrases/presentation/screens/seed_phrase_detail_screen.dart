import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/seed_phrase_entry.dart';

class SeedPhraseDetailScreen extends ConsumerStatefulWidget {
  final String entryId;

  const SeedPhraseDetailScreen({super.key, required this.entryId});

  @override
  ConsumerState<SeedPhraseDetailScreen> createState() =>
      _SeedPhraseDetailScreenState();
}

class _SeedPhraseDetailScreenState
    extends ConsumerState<SeedPhraseDetailScreen> {
  SeedPhraseEntry? _entry;
  bool _isLoading = true;
  bool _isPhraseVisible = false;
  bool _isNotesVisible = false;
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    try {
      final repository = ref.read(seedPhraseRepositoryProvider);
      final encryptionService = ref.read(encryptionServiceProvider);
      final key = ref.read(encryptionKeyProvider);
      final entry = await repository.getEntryById(widget.entryId);

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
          _entry = entry.copyWith(
            encryptedPhrase: decryptedPhrase,
            encryptedNotes: decryptedNotes,
          );
          _words = SeedPhraseEntry.getWords(decryptedPhrase);
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Seed phrase not found')),
      );
    }

    final entry = _entry!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/seeds/${entry.id}/edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blockchain info
            if (entry.blockchain != null) ...[
              _buildInfoCard(
                context,
                icon: Icons.currency_bitcoin,
                label: 'Blockchain',
                value: entry.blockchain!,
              ),
              const SizedBox(height: 12),
            ],

            // Wallet address
            if (entry.walletAddress != null) ...[
              _buildInfoCard(
                context,
                icon: Icons.account_balance_wallet,
                label: 'Wallet Address',
                value: entry.walletAddress!,
              ),
              const SizedBox(height: 12),
            ],

            // Seed phrase
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Seed Phrase (${_words.length} words)',
                          style: theme.textTheme.titleMedium,
                        ),
                        IconButton(
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
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isPhraseVisible)
                      _buildWordGrid(theme, colorScheme)
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 32,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the eye icon to reveal',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            if (entry.encryptedNotes != null) ...[
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Notes', style: theme.textTheme.titleMedium),
                          IconButton(
                            icon: Icon(
                              _isNotesVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNotesVisible = !_isNotesVisible;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isNotesVisible
                            ? entry.encryptedNotes!
                            : '\u2022' * 20,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Metadata
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMetaRow(context, 'Created',
                        _formatDate(entry.createdAt)),
                    const SizedBox(height: 8),
                    _buildMetaRow(context, 'Updated',
                        _formatDate(entry.updatedAt)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordGrid(ThemeData theme, ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_words.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${index + 1}.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _words[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon),
        title: Text(label, style: context.textTheme.bodySmall),
        subtitle: Text(
          value,
          style: context.textTheme.bodyLarge?.copyWith(
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        )),
        Text(value, style: context.textTheme.bodyMedium),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
