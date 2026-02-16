import 'dart:convert' show utf8;
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
    // SECURITY FIX: customFields should be encrypted just like password and notes
    // Try to decrypt customFields if present, fallback to null if decryption fails (old data)
    String? decryptedCustomFields;
    if (row.customFields != null && row.customFields!.isNotEmpty) {
      try {
        final key = _getEncryptionKey();
        decryptedCustomFields = _encryptionService.decryptText(row.customFields!, key);
      } catch (e) {
        // Old unencrypted data or corrupted - return null for security
        // Better to lose old custom fields than expose them
        decryptedCustomFields = null;
      }
    }

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
      customFields: decryptedCustomFields,
      encryptedTotpSecret: row.encryptedTotpSecret,
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

    // SECURITY FIX: Encrypt customFields just like password and notes
    final encryptedCustomFields = entry.customFields != null && entry.customFields!.isNotEmpty
        ? _encryptionService.encryptText(entry.customFields!, key)
        : null;

    final encryptedTotp = entry.encryptedTotpSecret != null && entry.encryptedTotpSecret!.isNotEmpty
        ? _encryptionService.encryptText(entry.encryptedTotpSecret!, key)
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
      customFields: Value(encryptedCustomFields),
      encryptedTotpSecret: Value(encryptedTotp),
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

    // SECURITY FIX: Encrypt customFields just like password and notes
    final encryptedCustomFields = entry.customFields != null && entry.customFields!.isNotEmpty
        ? _encryptionService.encryptText(entry.customFields!, key)
        : null;

    final encryptedTotp = entry.encryptedTotpSecret != null && entry.encryptedTotpSecret!.isNotEmpty
        ? _encryptionService.encryptText(entry.encryptedTotpSecret!, key)
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
      customFields: Value(encryptedCustomFields),
      encryptedTotpSecret: Value(encryptedTotp),
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
      // SECURITY FIX: Encrypt customFields during import
      final encryptedCustomFields = entry.customFields != null && entry.customFields!.isNotEmpty
          ? _encryptionService.encryptText(entry.customFields!, key)
          : null;

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
        customFields: Value(encryptedCustomFields),
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

  @override
  Future<void> reEncryptAllEntries(Uint8List oldKey, Uint8List newKey) async {
    // Use transaction to ensure atomicity - either all entries are re-encrypted or none
    await _entryDao.db.transaction(() async {
      final allEntries = await _entryDao.getAll(includeDeleted: true);

      // SECURITY FIX: Re-encrypt password entries
      for (final entry in allEntries) {
        String decryptedPassword = '';
        String? decryptedNotes;
        String? decryptedCustomFields;

        try {
          // Decrypt with old key
          decryptedPassword = _encryptionService.decryptText(
            entry.encryptedPassword,
            oldKey,
          );

          if (entry.encryptedNotes != null) {
            decryptedNotes = _encryptionService.decryptText(
              entry.encryptedNotes!,
              oldKey,
            );
          }

          // SECURITY FIX: Re-encrypt customFields
          if (entry.customFields != null && entry.customFields!.isNotEmpty) {
            try {
              decryptedCustomFields = _encryptionService.decryptText(
                entry.customFields!,
                oldKey,
              );
            } catch (e) {
              // Old unencrypted customFields - keep as null for security
              decryptedCustomFields = null;
            }
          }

          // Encrypt with new key
          final newEncPassword = _encryptionService.encryptText(
            decryptedPassword,
            newKey,
          );

          String? newEncNotes;
          if (decryptedNotes != null) {
            newEncNotes = _encryptionService.encryptText(decryptedNotes, newKey);
          }

          String? newEncCustomFields;
          if (decryptedCustomFields != null && decryptedCustomFields.isNotEmpty) {
            newEncCustomFields = _encryptionService.encryptText(decryptedCustomFields, newKey);
          }

          // Update entry
          await _entryDao.updateEntry(
            PasswordEntriesCompanion(
              id: Value(entry.id),
              encryptedPassword: Value(newEncPassword),
              encryptedNotes: Value(newEncNotes),
              customFields: Value(newEncCustomFields),
            ),
          );

        } finally {
          // Zero out decrypted data from memory
          if (decryptedPassword.isNotEmpty) {
            _encryptionService.zeroMemory(
              Uint8List.fromList(utf8.encode(decryptedPassword)),
            );
          }
          if (decryptedNotes != null) {
            _encryptionService.zeroMemory(
              Uint8List.fromList(utf8.encode(decryptedNotes)),
            );
          }
          if (decryptedCustomFields != null) {
            _encryptionService.zeroMemory(
              Uint8List.fromList(utf8.encode(decryptedCustomFields)),
            );
          }
        }
      }

      // SECURITY FIX: Re-encrypt password history
      final allHistory = await _historyDao.getAllHistory();
      for (final historyEntry in allHistory) {
        String decryptedOldPassword = '';

        try {
          // Decrypt old password with old key
          decryptedOldPassword = _encryptionService.decryptText(
            historyEntry.encryptedOldPassword,
            oldKey,
          );

          // Encrypt with new key
          final newEncOldPassword = _encryptionService.encryptText(
            decryptedOldPassword,
            newKey,
          );

          // Update history entry
          await _historyDao.updateHistory(
            PasswordHistoryEntriesCompanion(
              id: Value(historyEntry.id),
              encryptedOldPassword: Value(newEncOldPassword),
            ),
          );

        } finally {
          // Zero out decrypted data from memory
          if (decryptedOldPassword.isNotEmpty) {
            _encryptionService.zeroMemory(
              Uint8List.fromList(utf8.encode(decryptedOldPassword)),
            );
          }
        }
      }
    });
  }
}
