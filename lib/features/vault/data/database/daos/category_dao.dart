import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<Category>> watchAll() {
    return (select(categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<List<Category>> getAll() {
    return (select(categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<Category?> getById(String id) {
    return (select(categories)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<bool> updateCategory(CategoriesCompanion category) {
    return (update(categories)..where((t) => t.id.equals(category.id.value)))
        .write(category)
        .then((rows) => rows > 0);
  }

  Future<int> deleteCategory(String id) {
    return (delete(categories)..where((t) => t.id.equals(id))).go();
  }

  Future<void> reorder(List<String> orderedIds) async {
    await transaction(() async {
      for (int i = 0; i < orderedIds.length; i++) {
        await (update(categories)..where((t) => t.id.equals(orderedIds[i])))
            .write(CategoriesCompanion(
          sortOrder: Value(i),
          updatedAt: Value(DateTime.now().toUtc()),
        ));
      }
    });
  }
}
