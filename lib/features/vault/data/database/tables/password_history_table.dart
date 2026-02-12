import 'package:drift/drift.dart';

import 'password_entries_table.dart';

class PasswordHistoryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get entryId => text().references(PasswordEntries, #id)();
  TextColumn get encryptedOldPassword => text()();
  TextColumn get changedBy => text().withDefault(const Constant('user'))();
  DateTimeColumn get changedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
