import 'package:csv/csv.dart';
import '../../../vault/domain/entities/password_entry.dart';

class CsvExporter {
  /// Exports list of PasswordEntry to CSV format
  /// Format: name,url,username,password,notes
  /// Properly escapes CSV fields (handles commas, quotes, newlines)
  String export(List<PasswordEntry> entries) {
    try {
      // Prepare rows
      final List<List<String>> rows = [];

      // Add header row
      rows.add(['name', 'url', 'username', 'password', 'notes']);

      // Add data rows
      for (final entry in entries) {
        rows.add([
          entry.title,
          entry.url ?? '',
          entry.username,
          entry.encryptedPassword,
          entry.encryptedNotes ?? '',
        ]);
      }

      // Convert to CSV string
      const csvConverter = ListToCsvConverter();
      return csvConverter.convert(rows);
    } catch (e) {
      throw Exception('Failed to export to CSV: $e');
    }
  }
}
