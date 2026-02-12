import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../../../vault/domain/entities/password_entry.dart';

class ChromeCsvParser {
  final _uuid = const Uuid();

  /// Parses Chrome CSV format: name,url,username,password
  /// Returns list of PasswordEntry objects
  List<PasswordEntry> parse(String content) {
    try {
      final List<PasswordEntry> entries = [];

      // Parse CSV
      const csvConverter = CsvToListConverter();
      final List<List<dynamic>> rows = csvConverter.convert(content);

      // Skip header row and process data rows
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];

        // Skip empty rows
        if (row.isEmpty || (row.length == 1 && row[0].toString().trim().isEmpty)) {
          continue;
        }

        // Ensure we have at least 4 columns
        if (row.length < 4) {
          continue;
        }

        final name = row[0]?.toString().trim() ?? '';
        final url = row[1]?.toString().trim() ?? '';
        final username = row[2]?.toString().trim() ?? '';
        final password = row[3]?.toString().trim() ?? '';

        // Skip entries with no title or password
        if (name.isEmpty || password.isEmpty) {
          continue;
        }

        final now = DateTime.now();

        entries.add(PasswordEntry(
          id: _uuid.v4(),
          title: name,
          username: username,
          encryptedPassword: password,
          url: url.isNotEmpty ? url : null,
          encryptedNotes: null,
          categoryId: 'general',
          isFavorite: false,
          faviconUrl: null,
          customFields: null,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
        ));
      }

      return entries;
    } catch (e) {
      throw Exception('Failed to parse Chrome CSV: $e');
    }
  }
}
