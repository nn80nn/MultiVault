import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/password_entry.dart';
import '../../domain/entities/category.dart';

class VaultListScreen extends ConsumerStatefulWidget {
  const VaultListScreen({super.key});

  @override
  ConsumerState<VaultListScreen> createState() => _VaultListScreenState();
}

class _VaultListScreenState extends ConsumerState<VaultListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategoryId = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vaultRepository = ref.watch(vaultRepositoryProvider);
    final categoryRepository = ref.watch(categoryRepositoryProvider);
    final clipboardService = ref.watch(clipboardServiceProvider);
    final encryptionService = ref.watch(encryptionServiceProvider);
    final encryptionKey = ref.watch(encryptionKeyProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search passwords...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : const Text('Multivault'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          StreamBuilder<List<Category>>(
            stream: categoryRepository.watchAllCategories(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final categories = snapshot.data!;
              return Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategoryId == 'all',
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategoryId = 'all';
                          });
                        },
                      ),
                    ),
                    ...categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: _selectedCategoryId == category.id,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryId = category.id;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          // Vault Entries List
          Expanded(
            child: StreamBuilder<List<PasswordEntry>>(
              stream: vaultRepository.watchAllEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
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
                          'Error loading vault',
                          style: context.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final allEntries = snapshot.data ?? [];

                // Filter entries
                final filteredEntries = allEntries.where((entry) {
                  // Category filter
                  if (_selectedCategoryId != 'all' &&
                      entry.categoryId != _selectedCategoryId) {
                    return false;
                  }

                  // Search filter
                  if (_searchQuery.isNotEmpty) {
                    return entry.title.toLowerCase().contains(_searchQuery) ||
                        entry.username.toLowerCase().contains(_searchQuery) ||
                        (entry.url?.toLowerCase().contains(_searchQuery) ?? false);
                  }

                  return true;
                }).toList();

                // Sort: favorites first, then by title
                filteredEntries.sort((a, b) {
                  if (a.isFavorite != b.isFavorite) {
                    return a.isFavorite ? -1 : 1;
                  }
                  return a.title.compareTo(b.title);
                });

                if (filteredEntries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty
                              ? Icons.search_off
                              : Icons.lock_outline,
                          size: 64,
                          color: context.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No matching passwords'
                              : 'Add your first password',
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to get started',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredEntries.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final entry = filteredEntries[index];
                    return _buildVaultEntryItem(
                      context,
                      entry,
                      clipboardService,
                      encryptionService,
                      encryptionKey,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/vault/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVaultEntryItem(
    BuildContext context,
    PasswordEntry entry,
    dynamic clipboardService,
    dynamic encryptionService,
    Uint8List? encryptionKey,
  ) {
    return Slidable(
      key: ValueKey(entry.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              context.push('/vault/${entry.id}/edit');
            },
            backgroundColor: context.colorScheme.primary,
            foregroundColor: context.colorScheme.onPrimary,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              _showDeleteConfirmation(context, entry);
            },
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.primaryContainer,
          foregroundColor: context.colorScheme.onPrimaryContainer,
          child: Icon(_getIconForEntry(entry)),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (entry.isFavorite)
              Icon(
                Icons.star,
                size: 16,
                color: context.colorScheme.primary,
              ),
          ],
        ),
        subtitle: Text(
          entry.username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          tooltip: 'Copy password',
          onPressed: () async {
            if (encryptionKey != null) {
              try {
                final decryptedPassword = encryptionService.decryptText(
                  entry.encryptedPassword,
                  encryptionKey,
                );
                await clipboardService.copyAndScheduleClear(decryptedPassword);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  context.showSnackBar('Error decrypting password', isError: true);
                }
              }
            } else {
              if (context.mounted) {
                context.showSnackBar('Encryption key not available', isError: true);
              }
            }
          },
        ),
        onTap: () {
          context.push('/vault/${entry.id}');
        },
      ),
    );
  }

  IconData _getIconForEntry(PasswordEntry entry) {
    // Simple icon selection based on category or URL
    if (entry.url != null) {
      final url = entry.url!.toLowerCase();
      if (url.contains('google')) return Icons.g_mobiledata;
      if (url.contains('facebook')) return Icons.facebook;
      if (url.contains('twitter')) return Icons.tag;
      if (url.contains('github')) return Icons.code;
      if (url.contains('email') || url.contains('mail')) return Icons.email;
      return Icons.language;
    }
    return Icons.lock;
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    PasswordEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: Text(
          'Are you sure you want to delete "${entry.title}"? This action cannot be undone.',
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
        await vaultRepository.softDeleteEntry(entry.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted "${entry.title}"'),
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
