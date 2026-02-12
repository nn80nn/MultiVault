import '../entities/password_history.dart' as entity;

abstract class PasswordHistoryRepository {
  Future<List<entity.PasswordHistory>> getHistoryForEntry(String entryId);
  Stream<List<entity.PasswordHistory>> watchHistoryForEntry(String entryId);
  Future<void> addHistoryRecord(entity.PasswordHistory record);
  Future<void> deleteHistoryForEntry(String entryId);
}
