import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/seed_phrase_entry.dart';

class SeedPhraseListScreen extends ConsumerWidget {
  const SeedPhraseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(seedPhraseRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Phrases'),
      ),
      body: StreamBuilder<List<SeedPhraseEntry>>(
        stream: repository.watchAllEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Error loading seed phrases', style: context.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), style: context.textTheme.bodyMedium),
                ],
              ),
            );
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.key_outlined,
                    size: 64,
                    color: context.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No seed phrases yet',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a seed phrase',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: entries.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildEntryItem(context, ref, entry);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/seeds/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEntryItem(BuildContext context, WidgetRef ref, SeedPhraseEntry entry) {
    return Slidable(
      key: ValueKey(entry.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => context.push('/seeds/${entry.id}/edit'),
            backgroundColor: context.colorScheme.primary,
            foregroundColor: context.colorScheme.onPrimary,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => _showDeleteConfirmation(context, ref, entry),
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
          child: const Icon(Icons.key),
        ),
        title: Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          entry.blockchain ?? 'Unknown blockchain',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => context.push('/seeds/${entry.id}'),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    SeedPhraseEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Seed Phrase'),
        content: Text(
          'Are you sure you want to delete "${entry.name}"? This action cannot be undone.',
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
        final repository = ref.read(seedPhraseRepositoryProvider);
        await repository.softDeleteEntry(entry.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted "${entry.name}"')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          context.showSnackBar('Error deleting: $e', isError: true);
        }
      }
    }
  }
}
