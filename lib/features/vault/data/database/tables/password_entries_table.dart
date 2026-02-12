import 'package:drift/drift.dart';

import 'categories_table.dart';

class PasswordEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get username => text().withLength(max: 255)();
  TextColumn get encryptedPassword => text()();
  TextColumn get url => text().nullable()();
  TextColumn get encryptedNotes => text().nullable()();
  TextColumn get categoryId => text().references(Categories, #id)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get faviconUrl => text().nullable()();
  TextColumn get customFields => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
