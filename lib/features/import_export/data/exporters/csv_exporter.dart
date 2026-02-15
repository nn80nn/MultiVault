import 'package:csv/csv.dart';
import '../../../vault/domain/entities/password_entry.dart';

class CsvExporter {
  /// Exports list of PasswordEntry to CSV format
  /// Format: name,url,username,password,notes
  ///
  /// SECURITY WARNING: CSV exports passwords in PLAIN TEXT!
  /// - Entries MUST be pre-decrypted before passing to this method
  /// - The encryptedPassword field should contain DECRYPTED password (naming is misleading)
  /// - Output file will contain passwords readable by anyone
  /// - User MUST be warned about security implications
  ///
  /// Properly escapes CSV fields (handles commas, quotes, newlines)
  String export(List<PasswordEntry> entries) {
    try {
      // Prepare rows
      final List<List<String>> rows = [];

      // Add header row
      rows.add(['name', 'url', 'username', 'password', 'notes']);

      // Add data rows
      // SECURITY: Assumes entries are already decrypted!
      for (final entry in entries) {
        rows.add([
          entry.title,
          entry.url ?? '',
          entry.username,
          entry.encryptedPassword, // MISLEADING NAME: should be decrypted password
          entry.encryptedNotes ?? '', // MISLEADING NAME: should be decrypted notes
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
