import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../services/encryption_service.dart';
import '../../../vault/data/database/app_database.dart';
import '../../../vault/data/database/daos/seed_phrase_dao.dart';
import '../../domain/entities/seed_phrase_entry.dart';
import '../../domain/repositories/seed_phrase_repository.dart';

class SeedPhraseRepositoryImpl implements SeedPhraseRepository {
  final SeedPhraseDao _dao;
  final EncryptionService _encryptionService;
  final Uint8List Function() _getEncryptionKey;
  static const _uuid = Uuid();

  SeedPhraseRepositoryImpl({
    required SeedPhraseDao dao,
    required EncryptionService encryptionService,
    required Uint8List Function() getEncryptionKey,
  })  : _dao = dao,
        _encryptionService = encryptionService,
        _getEncryptionKey = getEncryptionKey;

  SeedPhraseEntry _fromDb(SeedPhrase row) {
    return SeedPhraseEntry(
      id: row.id,
      name: row.name,
      encryptedPhrase: row.encryptedPhrase,
      blockchain: row.blockchain,
      walletAddress: row.walletAddress,
      encryptedNotes: row.encryptedNotes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  @override
  Stream<List<SeedPhraseEntry>> watchAllEntries() {
    return _dao.watchAllActive().map(
          (rows) => rows.map(_fromDb).toList(),
        );
  }

  @override
  Future<SeedPhraseEntry?> getEntryById(String id) async {
    final row = await _dao.getById(id);
    return row != null ? _fromDb(row) : null;
  }

  @override
  Future<SeedPhraseEntry> createEntry(SeedPhraseEntry entry) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final key = _getEncryptionKey();

    final encryptedPhrase =
        _encryptionService.encryptText(entry.encryptedPhrase, key);
    final encryptedNotes = entry.encryptedNotes != null
        ? _encryptionService.encryptText(entry.encryptedNotes!, key)
        : null;

    final companion = SeedPhrasesCompanion.insert(
      id: id,
      name: entry.name,
      encryptedPhrase: encryptedPhrase,
      blockchain: Value(entry.blockchain),
      walletAddress: Value(entry.walletAddress),
      encryptedNotes: Value(encryptedNotes),
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertSeedPhrase(companion);

    return entry.copyWith(
      id: id,
      encryptedPhrase: encryptedPhrase,
      encryptedNotes: encryptedNotes,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> updateEntry(SeedPhraseEntry entry) async {
    final now = DateTime.now().toUtc();
    final key = _getEncryptionKey();

    final encryptedPhrase =
        _encryptionService.encryptText(entry.encryptedPhrase, key);
    final encryptedNotes = entry.encryptedNotes != null
        ? _encryptionService.encryptText(entry.encryptedNotes!, key)
        : null;

    final companion = SeedPhrasesCompanion(
      id: Value(entry.id),
      name: Value(entry.name),
      encryptedPhrase: Value(encryptedPhrase),
      blockchain: Value(entry.blockchain),
      walletAddress: Value(entry.walletAddress),
      encryptedNotes: Value(encryptedNotes),
      updatedAt: Value(now),
    );

    await _dao.updateSeedPhrase(companion);
  }

  @override
  Future<void> softDeleteEntry(String id) async {
    await _dao.softDelete(id);
  }

  @override
  Future<void> hardDeleteEntry(String id) async {
    await _dao.hardDelete(id);
  }
}
