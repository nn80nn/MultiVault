import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/seed_phrases_table.dart';

part 'seed_phrase_dao.g.dart';

@DriftAccessor(tables: [SeedPhrases])
class SeedPhraseDao extends DatabaseAccessor<AppDatabase>
    with _$SeedPhraseDaoMixin {
  SeedPhraseDao(super.db);

  Stream<List<SeedPhrase>> watchAllActive() {
    return (select(seedPhrases)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<List<SeedPhrase>> getAllActive() {
    return (select(seedPhrases)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<SeedPhrase?> getById(String id) {
    return (select(seedPhrases)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertSeedPhrase(SeedPhrasesCompanion entry) {
    return into(seedPhrases).insert(entry);
  }

  Future<bool> updateSeedPhrase(SeedPhrasesCompanion entry) {
    return (update(seedPhrases)..where((t) => t.id.equals(entry.id.value)))
        .write(entry)
        .then((rows) => rows > 0);
  }

  Future<bool> softDelete(String id) {
    return (update(seedPhrases)..where((t) => t.id.equals(id)))
        .write(SeedPhrasesCompanion(
          deletedAt: Value(DateTime.now().toUtc()),
          updatedAt: Value(DateTime.now().toUtc()),
        ))
        .then((rows) => rows > 0);
  }

  Future<int> hardDelete(String id) {
    return (delete(seedPhrases)..where((t) => t.id.equals(id))).go();
  }
}
