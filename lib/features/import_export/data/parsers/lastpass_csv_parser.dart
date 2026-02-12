import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../../../vault/domain/entities/password_entry.dart';

class LastpassCsvParser {
  final _uuid = const Uuid();

  /// Parses LastPass CSV format
  /// Format: url,username,password,totp,extra,name,grouping,fav
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

        // Ensure we have at least 6 columns to get name field
        if (row.length < 6) {
          continue;
        }

        final url = row[0]?.toString().trim() ?? '';
        final username = row[1]?.toString().trim() ?? '';
        final password = row[2]?.toString().trim() ?? '';
        // row[3] is totp - not used
        final extra = row.length > 4 ? row[4]?.toString().trim() ?? '' : '';
        final name = row.length > 5 ? row[5]?.toString().trim() ?? '' : '';
        // row[6] is grouping - could be used for categoryId in future
        final fav = row.length > 7 ? row[7]?.toString().trim() ?? '' : '';

        // Skip entries with no password
        if (password.isEmpty) {
          continue;
        }

        // Use name as title, fallback to URL or username
        String title = name;
        if (title.isEmpty) {
          if (url.isNotEmpty) {
            try {
              final uri = Uri.parse(url);
              title = uri.host.isNotEmpty ? uri.host : url;
              // Remove 'www.' prefix if present
              if (title.startsWith('www.')) {
                title = title.substring(4);
              }
            } catch (e) {
              title = url;
            }
          } else if (username.isNotEmpty) {
            title = username;
          } else {
            title = 'Imported Entry';
          }
        }

        final now = DateTime.now();

        entries.add(PasswordEntry(
          id: _uuid.v4(),
          title: title,
          username: username,
          encryptedPassword: password,
          url: url.isNotEmpty ? url : null,
          encryptedNotes: extra.isNotEmpty ? extra : null,
          categoryId: 'general',
          isFavorite: fav == '1',
          faviconUrl: null,
          customFields: null,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
        ));
      }

      return entries;
    } catch (e) {
      throw Exception('Failed to parse LastPass CSV: $e');
    }
  }
}
