import 'package:xml/xml.dart';
import 'package:uuid/uuid.dart';
import '../../../vault/domain/entities/password_entry.dart';

class KeepassXmlParser {
  final _uuid = const Uuid();

  /// Parses KeePass XML format
  /// Structure: <Root><Group><Entry> with <String><Key>Title</Key><Value>...</Value></String> elements
  /// Returns list of PasswordEntry objects
  List<PasswordEntry> parse(String content) {
    try {
      final List<PasswordEntry> entries = [];

      // Parse XML
      final document = XmlDocument.parse(content);

      // Find the Root element
      final rootElement = document.findAllElements('Root').firstOrNull;
      if (rootElement == null) {
        throw Exception('Invalid KeePass XML: Root element not found');
      }

      // Recursively process all groups and entries
      _processGroup(rootElement, entries);

      return entries;
    } catch (e) {
      throw Exception('Failed to parse KeePass XML: $e');
    }
  }

  /// Recursively processes groups and their entries
  void _processGroup(XmlElement groupElement, List<PasswordEntry> entries) {
    // Find all Entry elements in current group
    final entryElements = groupElement.findElements('Entry');
    for (final entryElement in entryElements) {
      final entry = _parseEntry(entryElement);
      if (entry != null) {
        entries.add(entry);
      }
    }

    // Recursively process nested groups
    final nestedGroups = groupElement.findElements('Group');
    for (final nestedGroup in nestedGroups) {
      _processGroup(nestedGroup, entries);
    }
  }

  /// Parses a single Entry element
  PasswordEntry? _parseEntry(XmlElement entryElement) {
    try {
      // Extract string fields from Entry
      final stringElements = entryElement.findElements('String');
      final Map<String, String> fields = {};

      for (final stringElement in stringElements) {
        final keyElement = stringElement.findElements('Key').firstOrNull;
        final valueElement = stringElement.findElements('Value').firstOrNull;

        if (keyElement != null && valueElement != null) {
          final key = keyElement.innerText;
          final value = valueElement.innerText;
          fields[key] = value;
        }
      }

      // Extract required fields
      final title = fields['Title']?.trim() ?? '';
      final username = fields['UserName']?.trim() ?? '';
      final password = fields['Password']?.trim() ?? '';
      final url = fields['URL']?.trim() ?? '';
      final notes = fields['Notes']?.trim() ?? '';

      // Skip entries with no password
      if (password.isEmpty) {
        return null;
      }

      // Skip entries with no title
      if (title.isEmpty) {
        return null;
      }

      final now = DateTime.now();

      return PasswordEntry(
        id: _uuid.v4(),
        title: title,
        username: username,
        encryptedPassword: password,
        url: url.isNotEmpty ? url : null,
        encryptedNotes: notes.isNotEmpty ? notes : null,
        categoryId: 'general',
        isFavorite: false,
        faviconUrl: null,
        customFields: null,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
      );
    } catch (e) {
      // Skip invalid entries
      return null;
    }
  }
}
