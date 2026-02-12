import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../../vault/domain/entities/password_entry.dart';

class GenericJsonParser {
  final _uuid = const Uuid();

  /// Parses generic JSON format (array of objects)
  /// Tries multiple common field names for each property
  /// Returns list of PasswordEntry objects
  List<PasswordEntry> parse(String content) {
    try {
      final List<PasswordEntry> entries = [];

      // Parse JSON
      final dynamic jsonData = json.decode(content);

      // Handle both array and object with entries array
      List<dynamic> items = [];
      if (jsonData is List) {
        items = jsonData;
      } else if (jsonData is Map) {
        // Try to find an array in common field names
        if (jsonData['entries'] is List) {
          items = jsonData['entries'];
        } else if (jsonData['passwords'] is List) {
          items = jsonData['passwords'];
        } else if (jsonData['items'] is List) {
          items = jsonData['items'];
        } else if (jsonData['data'] is List) {
          items = jsonData['data'];
        }
      }

      // Process each item
      for (final item in items) {
        if (item is! Map) {
          continue;
        }

        final entry = _parseItem(item);
        if (entry != null) {
          entries.add(entry);
        }
      }

      return entries;
    } catch (e) {
      throw Exception('Failed to parse generic JSON: $e');
    }
  }

  /// Parses a single JSON object into PasswordEntry
  PasswordEntry? _parseItem(Map<dynamic, dynamic> item) {
    try {
      // Try to extract title/name
      final title = _findField(item, [
        'title',
        'name',
        'site',
        'website',
        'service',
        'account',
      ])?.toString().trim() ?? '';

      // Try to extract username
      final username = _findField(item, [
        'username',
        'user',
        'login',
        'email',
        'account',
        'identifier',
      ])?.toString().trim() ?? '';

      // Try to extract password
      final password = _findField(item, [
        'password',
        'pass',
        'pwd',
        'secret',
        'encryptedPassword',
      ])?.toString().trim() ?? '';

      // Try to extract URL
      final url = _findField(item, [
        'url',
        'website',
        'site',
        'link',
        'domain',
      ])?.toString().trim() ?? '';

      // Try to extract notes
      final notes = _findField(item, [
        'notes',
        'note',
        'comment',
        'comments',
        'description',
        'extra',
        'encryptedNotes',
      ])?.toString().trim() ?? '';

      // Try to extract favorite status
      final favoriteValue = _findField(item, [
        'favorite',
        'isFavorite',
        'fav',
        'starred',
      ]);
      bool isFavorite = false;
      if (favoriteValue != null) {
        if (favoriteValue is bool) {
          isFavorite = favoriteValue;
        } else if (favoriteValue is String) {
          isFavorite = favoriteValue.toLowerCase() == 'true' ||
                       favoriteValue == '1' ||
                       favoriteValue.toLowerCase() == 'yes';
        } else if (favoriteValue is num) {
          isFavorite = favoriteValue != 0;
        }
      }

      // Skip entries with no password
      if (password.isEmpty) {
        return null;
      }

      // Generate title if empty
      String finalTitle = title;
      if (finalTitle.isEmpty) {
        if (url.isNotEmpty) {
          try {
            final uri = Uri.parse(url);
            finalTitle = uri.host.isNotEmpty ? uri.host : url;
            if (finalTitle.startsWith('www.')) {
              finalTitle = finalTitle.substring(4);
            }
          } catch (e) {
            finalTitle = url;
          }
        } else if (username.isNotEmpty) {
          finalTitle = username;
        } else {
          finalTitle = 'Imported Entry';
        }
      }

      final now = DateTime.now();

      return PasswordEntry(
        id: _uuid.v4(),
        title: finalTitle,
        username: username,
        encryptedPassword: password,
        url: url.isNotEmpty ? url : null,
        encryptedNotes: notes.isNotEmpty ? notes : null,
        categoryId: 'general',
        isFavorite: isFavorite,
        faviconUrl: null,
        customFields: null,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
      );
    } catch (e) {
      // Skip invalid items
      return null;
    }
  }

  /// Finds a field value by trying multiple possible field names
  dynamic _findField(Map<dynamic, dynamic> item, List<String> possibleNames) {
    for (final name in possibleNames) {
      // Try exact match
      if (item.containsKey(name)) {
        return item[name];
      }

      // Try case-insensitive match
      for (final key in item.keys) {
        if (key.toString().toLowerCase() == name.toLowerCase()) {
          return item[key];
        }
      }
    }
    return null;
  }
}
