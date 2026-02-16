import 'package:drift/drift.dart';

class SeedPhrases extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get encryptedPhrase => text()();
  TextColumn get blockchain => text().nullable()();
  TextColumn get walletAddress => text().nullable()();
  TextColumn get encryptedNotes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
