import '../entities/password_entry.dart' as entity;

abstract class VaultRepository {
  Stream<List<entity.PasswordEntry>> watchAllEntries();
  Future<entity.PasswordEntry?> getEntryById(String id);
  Future<List<entity.PasswordEntry>> searchEntries(String query);
  Future<List<entity.PasswordEntry>> getEntriesByCategory(String categoryId);
  Future<List<entity.PasswordEntry>> getFavoriteEntries();
  Future<entity.PasswordEntry> createEntry(entity.PasswordEntry entry);
  Future<void> updateEntry(entity.PasswordEntry entry);
  Future<void> softDeleteEntry(String id);
  Future<void> hardDeleteEntry(String id);
  Future<int> importEntries(List<entity.PasswordEntry> entries);
  Future<List<entity.PasswordEntry>> getAllEntriesForExport({
    bool includeDeleted = false,
  });
  Future<Map<String, int>> getEntryCounts();
}
