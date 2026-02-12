import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../../../vault/domain/entities/password_entry.dart';

class FirefoxCsvParser {
  final _uuid = const Uuid();

  /// Parses Firefox CSV format
  /// Format: "url","username","password","httpRealm","formActionOrigin","guid","timeCreated","timeLastUsed","timePasswordChanged"
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

        // Ensure we have at least 3 columns (url, username, password)
        if (row.length < 3) {
          continue;
        }

        final url = row[0]?.toString().trim() ?? '';
        final username = row[1]?.toString().trim() ?? '';
        final password = row[2]?.toString().trim() ?? '';

        // Skip entries with no password
        if (password.isEmpty) {
          continue;
        }

        // Extract title from URL hostname
        String title = url;
        if (url.isNotEmpty) {
          try {
            final uri = Uri.parse(url);
            title = uri.host.isNotEmpty ? uri.host : url;
            // Remove 'www.' prefix if present
            if (title.startsWith('www.')) {
              title = title.substring(4);
            }
          } catch (e) {
            // If URL parsing fails, use the URL as title
            title = url;
          }
        }

        // If title is still empty, use username or default
        if (title.isEmpty) {
          title = username.isNotEmpty ? username : 'Imported Entry';
        }

        final now = DateTime.now();

        entries.add(PasswordEntry(
          id: _uuid.v4(),
          title: title,
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
      throw Exception('Failed to parse Firefox CSV: $e');
    }
  }
}
