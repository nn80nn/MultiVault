import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../vault/domain/entities/category.dart';

class CategoriesManagementScreen extends ConsumerWidget {
  const CategoriesManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(categoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Category>>(
        stream: repository.watchAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;

          if (categories.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildCategoriesList(context, ref, categories);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No categories yet',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first category',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, WidgetRef ref, List<Category> categories) {
    final theme = Theme.of(context);

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categories.length,
      onReorder: (oldIndex, newIndex) {
        _reorderCategories(ref, categories, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final category = categories[index];
        return Dismissible(
          key: ValueKey(category.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) => _confirmDelete(context, ref, category),
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          child: Card(
            key: ValueKey(category.id),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.drag_handle,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _getIconData(category.iconName),
                    color: Color(category.colorValue),
                    size: 28,
                  ),
                ],
              ),
              title: Text(
                category.name,
                style: theme.textTheme.titleMedium,
              ),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(category.colorValue),
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () => _showAddEditDialog(context, ref, category: category),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'folder': Icons.folder,
      'work': Icons.work,
      'shopping_bag': Icons.shopping_bag,
      'email': Icons.email,
      'account_balance': Icons.account_balance,
      'credit_card': Icons.credit_card,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'sports_esports': Icons.sports_esports,
      'music_note': Icons.music_note,
      'movie': Icons.movie,
      'restaurant': Icons.restaurant,
      'flight': Icons.flight,
      'home': Icons.home,
      'directions_car': Icons.directions_car,
      'phone': Icons.phone,
      'computer': Icons.computer,
      'cloud': Icons.cloud,
      'lock': Icons.lock,
      'vpn_key': Icons.vpn_key,
    };
    return iconMap[iconName] ?? Icons.folder;
  }

  String _getIconName(IconData iconData) {
    final iconMap = {
      Icons.folder: 'folder',
      Icons.work: 'work',
      Icons.shopping_bag: 'shopping_bag',
      Icons.email: 'email',
      Icons.account_balance: 'account_balance',
      Icons.credit_card: 'credit_card',
      Icons.local_hospital: 'local_hospital',
      Icons.school: 'school',
      Icons.sports_esports: 'sports_esports',
      Icons.music_note: 'music_note',
      Icons.movie: 'movie',
      Icons.restaurant: 'restaurant',
      Icons.flight: 'flight',
      Icons.home: 'home',
      Icons.directions_car: 'directions_car',
      Icons.phone: 'phone',
      Icons.computer: 'computer',
      Icons.cloud: 'cloud',
      Icons.lock: 'lock',
      Icons.vpn_key: 'vpn_key',
    };
    return iconMap[iconData] ?? 'folder';
  }

  Future<void> _reorderCategories(
    WidgetRef ref,
    List<Category> categories,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final orderedIds = List<String>.from(categories.map((c) => c.id));
    final movedId = orderedIds.removeAt(oldIndex);
    orderedIds.insert(newIndex, movedId);

    final repository = ref.read(categoryRepositoryProvider);
    await repository.reorderCategories(orderedIds);
  }

  Future<bool> _confirmDelete(BuildContext context, WidgetRef ref, Category category) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.deleteCategory(category.id);
    }

    return result ?? false;
  }

  Future<void> _showAddEditDialog(
    BuildContext context,
    WidgetRef ref, {
    Category? category,
  }) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => _AddEditCategoryDialog(
        category: category,
        getIconName: _getIconName,
        getIconData: _getIconData,
      ),
    );

    if (result != null) {
      final repository = ref.read(categoryRepositoryProvider);
      if (category == null) {
        await repository.createCategory(result);
        if (context.mounted) {
          context.showSnackBar('Category created');
        }
      } else {
        await repository.updateCategory(result);
        if (context.mounted) {
          context.showSnackBar('Category updated');
        }
      }
    }
  }
}

class _AddEditCategoryDialog extends StatefulWidget {
  final Category? category;
  final String Function(IconData) getIconName;
  final IconData Function(String) getIconData;

  const _AddEditCategoryDialog({
    this.category,
    required this.getIconName,
    required this.getIconData,
  });

  @override
  State<_AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<_AddEditCategoryDialog> {
  late TextEditingController _nameController;
  late IconData _selectedIcon;
  late int _selectedColor;

  static const _commonIcons = [
    Icons.folder,
    Icons.work,
    Icons.shopping_bag,
    Icons.email,
    Icons.account_balance,
    Icons.credit_card,
    Icons.local_hospital,
    Icons.school,
    Icons.sports_esports,
    Icons.music_note,
    Icons.movie,
    Icons.restaurant,
    Icons.flight,
    Icons.home,
    Icons.directions_car,
    Icons.phone,
    Icons.computer,
    Icons.cloud,
    Icons.lock,
    Icons.vpn_key,
  ];

  static const _commonColors = [
    0xFFEF5350, // Red
    0xFFEC407A, // Pink
    0xFFAB47BC, // Purple
    0xFF7E57C2, // Deep Purple
    0xFF5C6BC0, // Indigo
    0xFF42A5F5, // Blue
    0xFF29B6F6, // Light Blue
    0xFF26C6DA, // Cyan
    0xFF26A69A, // Teal
    0xFF66BB6A, // Green
    0xFF9CCC65, // Light Green
    0xFFD4E157, // Lime
    0xFFFFEE58, // Yellow
    0xFFFFCA28, // Amber
    0xFFFF9800, // Orange
    0xFFFF7043, // Deep Orange
    0xFF8D6E63, // Brown
    0xFF78909C, // Blue Grey
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category != null
        ? widget.getIconData(widget.category!.iconName)
        : Icons.folder;
    _selectedColor = widget.category?.colorValue ?? _commonColors[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.category != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Category' : 'Add Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),

            // Icon Picker
            Text(
              'Icon',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _commonIcons.length,
                itemBuilder: (context, index) {
                  final icon = _commonIcons[index];
                  final isSelected = icon == _selectedIcon;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedIcon = icon);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Color Picker
            Text(
              'Color',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonColors.map((color) {
                final isSelected = color == _selectedColor;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedColor = color);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 3,
                            )
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () {
                  final now = DateTime.now();
                  final category = Category(
                    id: widget.category?.id ?? '',
                    name: _nameController.text.trim(),
                    iconName: widget.getIconName(_selectedIcon),
                    colorValue: _selectedColor,
                    sortOrder: widget.category?.sortOrder ?? 0,
                    createdAt: widget.category?.createdAt ?? now,
                    updatedAt: now,
                  );
                  Navigator.of(context).pop(category);
                },
          child: Text(isEdit ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
