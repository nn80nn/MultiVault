import '../entities/seed_phrase_entry.dart';

abstract class SeedPhraseRepository {
  Stream<List<SeedPhraseEntry>> watchAllEntries();
  Future<SeedPhraseEntry?> getEntryById(String id);
  Future<SeedPhraseEntry> createEntry(SeedPhraseEntry entry);
  Future<void> updateEntry(SeedPhraseEntry entry);
  Future<void> softDeleteEntry(String id);
  Future<void> hardDeleteEntry(String id);
}
