import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/db_constants.dart';
import 'daos/category_dao.dart';
import 'daos/password_entry_dao.dart';
import 'daos/password_history_dao.dart';
import 'tables/categories_table.dart';
import 'tables/password_entries_table.dart';
import 'tables/password_history_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [PasswordEntries, Categories, PasswordHistoryEntries],
  daos: [PasswordEntryDao, CategoryDao, PasswordHistoryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations
        },
      );

  Future<void> _seedDefaultCategories() async {
    const uuid = Uuid();
    final now = DateTime.now().toUtc();
    final defaults = [
      ('General', 'folder', 0xFF6750A4, 0),
      ('Social', 'people', 0xFF2196F3, 1),
      ('Banking', 'account_balance', 0xFF4CAF50, 2),
      ('Email', 'email', 0xFFFF9800, 3),
      ('Shopping', 'shopping_cart', 0xFFE91E63, 4),
      ('Work', 'work', 0xFF607D8B, 5),
      ('Entertainment', 'movie', 0xFF9C27B0, 6),
    ];

    for (final (name, icon, color, order) in defaults) {
      await into(categories).insert(CategoriesCompanion.insert(
        id: uuid.v4(),
        name: name,
        iconName: Value(icon),
        colorValue: color,
        sortOrder: Value(order),
        createdAt: now,
        updatedAt: now,
      ));
    }
  }

  static Future<AppDatabase> openEncrypted(String encryptionKey) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, DbConstants.dbFileName));

    return AppDatabase(
      NativeDatabase.createInBackground(
        file,
        isolateSetup: () async {
          open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
        },
        setup: (db) {
          db.execute("PRAGMA key = '$encryptionKey'");
          db.execute('PRAGMA journal_mode = WAL');
          db.execute('PRAGMA foreign_keys = ON');
        },
      ),
    );
  }
}
