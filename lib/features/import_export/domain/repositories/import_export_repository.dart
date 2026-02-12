import '../../domain/entities/export_config.dart';
import '../../../vault/domain/entities/password_entry.dart';

enum ImportFormat { chromeCsv, firefoxCsv, lastPassCsv, keepassXml, genericJson }

abstract class ImportExportRepository {
  Future<List<PasswordEntry>> parseImportFile(
      String filePath, ImportFormat format);
  Future<String> exportToFile(
      List<PasswordEntry> entries, ExportConfig config);
}
