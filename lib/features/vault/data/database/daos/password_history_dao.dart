import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/password_history_table.dart';

part 'password_history_dao.g.dart';

@DriftAccessor(tables: [PasswordHistoryEntries])
class PasswordHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$PasswordHistoryDaoMixin {
  PasswordHistoryDao(super.db);

  Future<List<PasswordHistoryEntry>> getHistoryForEntry(String entryId) {
    return (select(passwordHistoryEntries)
          ..where((t) => t.entryId.equals(entryId))
          ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .get();
  }

  Stream<List<PasswordHistoryEntry>> watchHistoryForEntry(String entryId) {
    return (select(passwordHistoryEntries)
          ..where((t) => t.entryId.equals(entryId))
          ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .watch();
  }

  Future<int> insertHistory(PasswordHistoryEntriesCompanion record) {
    return into(passwordHistoryEntries).insert(record);
  }

  Future<int> deleteHistoryForEntry(String entryId) {
    return (delete(passwordHistoryEntries)
          ..where((t) => t.entryId.equals(entryId)))
        .go();
  }
}
