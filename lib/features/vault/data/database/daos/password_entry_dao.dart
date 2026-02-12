import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/password_entries_table.dart';

part 'password_entry_dao.g.dart';

@DriftAccessor(tables: [PasswordEntries])
class PasswordEntryDao extends DatabaseAccessor<AppDatabase>
    with _$PasswordEntryDaoMixin {
  PasswordEntryDao(super.db);

  Stream<List<PasswordEntry>> watchAllActive() {
    return (select(passwordEntries)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<List<PasswordEntry>> getAllActive() {
    return (select(passwordEntries)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<List<PasswordEntry>> getAll({bool includeDeleted = false}) {
    if (includeDeleted) {
      return select(passwordEntries).get();
    }
    return getAllActive();
  }

  Future<PasswordEntry?> getById(String id) {
    return (select(passwordEntries)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<PasswordEntry>> searchEntries(String query) {
    final pattern = '%$query%';
    return (select(passwordEntries)
          ..where((t) =>
              t.deletedAt.isNull() &
              (t.title.like(pattern) |
                  t.username.like(pattern) |
                  t.url.like(pattern)))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<List<PasswordEntry>> getByCategory(String categoryId) {
    return (select(passwordEntries)
          ..where(
              (t) => t.deletedAt.isNull() & t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<List<PasswordEntry>> getFavorites() {
    return (select(passwordEntries)
          ..where((t) => t.deletedAt.isNull() & t.isFavorite.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<int> insertEntry(PasswordEntriesCompanion entry) {
    return into(passwordEntries).insert(entry);
  }

  Future<bool> updateEntry(PasswordEntriesCompanion entry) {
    return (update(passwordEntries)..where((t) => t.id.equals(entry.id.value)))
        .write(entry)
        .then((rows) => rows > 0);
  }

  Future<bool> softDelete(String id) {
    return (update(passwordEntries)..where((t) => t.id.equals(id)))
        .write(PasswordEntriesCompanion(
          deletedAt: Value(DateTime.now().toUtc()),
          updatedAt: Value(DateTime.now().toUtc()),
        ))
        .then((rows) => rows > 0);
  }

  Future<int> hardDelete(String id) {
    return (delete(passwordEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> insertBulk(List<PasswordEntriesCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(passwordEntries, entries);
    });
  }

  Future<Map<String, int>> getEntryCounts() async {
    final query = selectOnly(passwordEntries)
      ..where(passwordEntries.deletedAt.isNull())
      ..addColumns([passwordEntries.categoryId, countAll()])
      ..groupBy([passwordEntries.categoryId]);

    final results = await query.get();
    final counts = <String, int>{};
    for (final row in results) {
      final categoryId = row.read(passwordEntries.categoryId);
      final count = row.read(countAll());
      if (categoryId != null && count != null) {
        counts[categoryId] = count;
      }
    }
    return counts;
  }
}
