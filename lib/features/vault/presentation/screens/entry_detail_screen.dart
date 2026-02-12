import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';

class EntryDetailScreen extends ConsumerWidget {
  final String entryId;

  const EntryDetailScreen({
    super.key,
    required this.entryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultRepository = ref.watch(vaultRepositoryProvider);
    final categoryRepository = ref.watch(categoryRepositoryProvider);
    final clipboardService = ref.watch(clipboardServiceProvider);
    final encryptionService = ref.watch(encryptionServiceProvider);
    final encryptionKey = ref.watch(encryptionKeyProvider);

    return FutureBuilder(
      future: vaultRepository.getEntryById(entryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Entry not found',
                    style: context.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        }

        final entry = snapshot.data!;

        // Decrypt password and notes
        String? decryptedPassword;
        String? decryptedNotes;
        if (encryptionKey != null) {
          try {
            decryptedPassword = encryptionService.decryptText(
              entry.encryptedPassword,
              encryptionKey,
            );
            if (entry.encryptedNotes != null) {
              decryptedNotes = encryptionService.decryptText(
                entry.encryptedNotes!,
                encryptionKey,
              );
            }
          } catch (e) {
            // Handle decryption error
            decryptedPassword = 'Error decrypting';
            decryptedNotes = entry.encryptedNotes != null ? 'Error decrypting' : null;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(entry.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.push('/vault/$entryId/edit');
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmation(context, ref, entry.title);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Favorite indicator
                if (entry.isFavorite)
                  Card(
                    color: context.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Favorite',
                            style: context.textTheme.labelLarge?.copyWith(
                              color: context.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (entry.isFavorite) const SizedBox(height: 16),

                // Main info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        _DetailRow(
                          label: 'Username',
                          value: entry.username,
                          icon: Icons.person,
                          onCopy: () async {
                            await clipboardService
                                .copyAndScheduleClear(entry.username);
                            if (context.mounted) {
                              _showCopiedSnackbar(context, 'Username');
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        if (decryptedPassword != null)
                          _PasswordRow(
                            password: decryptedPassword,
                            onCopy: () async {
                              await clipboardService
                                  .copyAndScheduleClear(decryptedPassword!);
                              if (context.mounted) {
                                _showCopiedSnackbar(context, 'Password');
                              }
                            },
                          ),
                        const SizedBox(height: 16),

                        // URL
                        if (entry.url != null && entry.url!.isNotEmpty) ...[
                          _DetailRow(
                            label: 'URL',
                            value: entry.url!,
                            icon: Icons.link,
                            onCopy: () async {
                              await clipboardService.copyAndScheduleClear(entry.url!);
                              if (context.mounted) {
                                _showCopiedSnackbar(context, 'URL');
                              }
                            },
                            onOpen: () {
                              // In a real app, use url_launcher package
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('URL launcher not implemented'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Notes
                        if (decryptedNotes != null && decryptedNotes.isNotEmpty) ...[
                          Text(
                            'Notes',
                            style: context.textTheme.labelMedium?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              decryptedNotes,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                FutureBuilder(
                  future: categoryRepository.getCategoryById(entry.categoryId),
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.hasData) {
                      final category = categorySnapshot.data!;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder,
                                color: context.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Category',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Chip(
                                label: Text(category.name),
                                avatar: Icon(
                                  Icons.category,
                                  size: 18,
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),

                // Timestamps
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color:
                                  context.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Created',
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              entry.createdAt.relativeTime,
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.update,
                              size: 16,
                              color:
                                  context.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Updated',
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              entry.updatedAt.relativeTime,
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCopiedSnackbar(BuildContext context, String item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: Text(
          'Are you sure you want to delete "$title"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final vaultRepository = ref.read(vaultRepositoryProvider);
        await vaultRepository.softDeleteEntry(entryId);
        if (context.mounted) {
          context.pop(); // Go back to list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted "$title"'),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          context.showSnackBar('Error deleting entry: $e', isError: true);
        }
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onCopy;
  final VoidCallback? onOpen;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onCopy,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: context.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: context.textTheme.bodyLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              iconSize: 20,
              onPressed: onCopy,
              tooltip: 'Copy',
            ),
            if (onOpen != null)
              IconButton(
                icon: const Icon(Icons.open_in_new),
                iconSize: 20,
                onPressed: onOpen,
                tooltip: 'Open',
              ),
          ],
        ),
      ],
    );
  }
}

class _PasswordRow extends StatefulWidget {
  final String password;
  final VoidCallback onCopy;

  const _PasswordRow({
    required this.password,
    required this.onCopy,
  });

  @override
  State<_PasswordRow> createState() => _PasswordRowState();
}

class _PasswordRowState extends State<_PasswordRow> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.lock,
              size: 20,
              color: context.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isObscured ? '••••••••••••' : widget.password,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontFamily: _isObscured ? null : 'monospace',
                ),
              ),
            ),
            IconButton(
              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
              iconSize: 20,
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
              tooltip: _isObscured ? 'Show' : 'Hide',
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              iconSize: 20,
              onPressed: widget.onCopy,
              tooltip: 'Copy',
            ),
          ],
        ),
      ],
    );
  }
}
