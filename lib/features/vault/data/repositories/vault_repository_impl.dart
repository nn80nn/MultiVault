import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../services/encryption_service.dart';
import '../../domain/entities/password_entry.dart' as entity;
import '../../domain/repositories/vault_repository.dart';
import '../database/app_database.dart';
import '../database/daos/password_entry_dao.dart';
import '../database/daos/password_history_dao.dart';

class VaultRepositoryImpl implements VaultRepository {
  final PasswordEntryDao _entryDao;
  final PasswordHistoryDao _historyDao;
  final EncryptionService _encryptionService;
  final Uint8List Function() _getEncryptionKey;
  static const _uuid = Uuid();

  VaultRepositoryImpl({
    required PasswordEntryDao entryDao,
    required PasswordHistoryDao historyDao,
    required EncryptionService encryptionService,
    required Uint8List Function() getEncryptionKey,
  })  : _entryDao = entryDao,
        _historyDao = historyDao,
        _encryptionService = encryptionService,
        _getEncryptionKey = getEncryptionKey;

  entity.PasswordEntry _fromDb(PasswordEntry row) {
    return entity.PasswordEntry(
      id: row.id,
      title: row.title,
      username: row.username,
      encryptedPassword: row.encryptedPassword,
      url: row.url,
      encryptedNotes: row.encryptedNotes,
      categoryId: row.categoryId,
      isFavorite: row.isFavorite,
      faviconUrl: row.faviconUrl,
      customFields: row.customFields,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  @override
  Stream<List<entity.PasswordEntry>> watchAllEntries() {
    return _entryDao.watchAllActive().map(
          (rows) => rows.map(_fromDb).toList(),
        );
  }

  @override
  Future<entity.PasswordEntry?> getEntryById(String id) async {
    final row = await _entryDao.getById(id);
    return row != null ? _fromDb(row) : null;
  }

  @override
  Future<List<entity.PasswordEntry>> searchEntries(String query) async {
    final rows = await _entryDao.searchEntries(query);
    return rows.map(_fromDb).toList();
  }

  @override
  Future<List<entity.PasswordEntry>> getEntriesByCategory(
      String categoryId) async {
    final rows = await _entryDao.getByCategory(categoryId);
    return rows.map(_fromDb).toList();
  }

  @override
  Future<List<entity.PasswordEntry>> getFavoriteEntries() async {
    final rows = await _entryDao.getFavorites();
    return rows.map(_fromDb).toList();
  }

  @override
  Future<entity.PasswordEntry> createEntry(entity.PasswordEntry entry) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final key = _getEncryptionKey();

    final encryptedPassword =
        _encryptionService.encryptText(entry.encryptedPassword, key);
    final encryptedNotes = entry.encryptedNotes != null
        ? _encryptionService.encryptText(entry.encryptedNotes!, key)
        : null;

    final companion = PasswordEntriesCompanion.insert(
      id: id,
      title: entry.title,
      username: entry.username,
      encryptedPassword: encryptedPassword,
      url: Value(entry.url),
      encryptedNotes: Value(encryptedNotes),
      categoryId: entry.categoryId,
      isFavorite: Value(entry.isFavorite),
      faviconUrl: Value(entry.faviconUrl),
      customFields: Value(entry.customFields),
      createdAt: now,
      updatedAt: now,
    );

    await _entryDao.insertEntry(companion);

    return entry.copyWith(
      id: id,
      encryptedPassword: encryptedPassword,
      encryptedNotes: encryptedNotes,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> updateEntry(entity.PasswordEntry entry) async {
    final now = DateTime.now().toUtc();
    final key = _getEncryptionKey();

    // Check if password changed for history logging
    final existing = await _entryDao.getById(entry.id);
    if (existing != null &&
        existing.encryptedPassword != entry.encryptedPassword) {
      // Log old password to history
      await _historyDao.insertHistory(
        PasswordHistoryEntriesCompanion.insert(
          id: _uuid.v4(),
          entryId: entry.id,
          encryptedOldPassword: existing.encryptedPassword,
          changedAt: now,
        ),
      );
    }

    final encryptedPassword =
        _encryptionService.encryptText(entry.encryptedPassword, key);
    final encryptedNotes = entry.encryptedNotes != null
        ? _encryptionService.encryptText(entry.encryptedNotes!, key)
        : null;

    final companion = PasswordEntriesCompanion(
      id: Value(entry.id),
      title: Value(entry.title),
      username: Value(entry.username),
      encryptedPassword: Value(encryptedPassword),
      url: Value(entry.url),
      encryptedNotes: Value(encryptedNotes),
      categoryId: Value(entry.categoryId),
      isFavorite: Value(entry.isFavorite),
      faviconUrl: Value(entry.faviconUrl),
      customFields: Value(entry.customFields),
      updatedAt: Value(now),
    );

    await _entryDao.updateEntry(companion);
  }

  @override
  Future<void> softDeleteEntry(String id) async {
    await _entryDao.softDelete(id);
  }

  @override
  Future<void> hardDeleteEntry(String id) async {
    await _historyDao.deleteHistoryForEntry(id);
    await _entryDao.hardDelete(id);
  }

  @override
  Future<int> importEntries(List<entity.PasswordEntry> entries) async {
    final now = DateTime.now().toUtc();
    final key = _getEncryptionKey();
    final companions = entries.map((entry) {
      return PasswordEntriesCompanion.insert(
        id: _uuid.v4(),
        title: entry.title,
        username: entry.username,
        encryptedPassword:
            _encryptionService.encryptText(entry.encryptedPassword, key),
        url: Value(entry.url),
        encryptedNotes: entry.encryptedNotes != null
            ? Value(_encryptionService.encryptText(entry.encryptedNotes!, key))
            : const Value.absent(),
        categoryId: entry.categoryId,
        isFavorite: Value(entry.isFavorite),
        createdAt: now,
        updatedAt: now,
      );
    }).toList();

    await _entryDao.insertBulk(companions);
    return companions.length;
  }

  @override
  Future<List<entity.PasswordEntry>> getAllEntriesForExport({
    bool includeDeleted = false,
  }) async {
    final rows = await _entryDao.getAll(includeDeleted: includeDeleted);
    return rows.map(_fromDb).toList();
  }

  @override
  Future<Map<String, int>> getEntryCounts() {
    return _entryDao.getEntryCounts();
  }
}
