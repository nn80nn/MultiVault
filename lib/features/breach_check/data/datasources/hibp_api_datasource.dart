import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/breach_result.dart';

class HibpApiDatasource {
  static const _baseUrl = 'https://api.pwnedpasswords.com/range/';
  final http.Client _client;

  HibpApiDatasource([http.Client? client])
      : _client = client ?? http.Client();

  Future<BreachResult> checkPassword(String plainPassword) async {
    final sha1Hash =
        sha1.convert(utf8.encode(plainPassword)).toString().toUpperCase();

    final prefix = sha1Hash.substring(0, 5);
    final suffix = sha1Hash.substring(5);

    final response = await _client.get(Uri.parse('$_baseUrl$prefix'));

    if (response.statusCode != 200) {
      return BreachResult(
        isBreached: false,
        occurrenceCount: 0,
        checkedAt: DateTime.now().toUtc(),
      );
    }

    final lines = response.body.split('\n');
    for (final line in lines) {
      final parts = line.split(':');
      if (parts.isNotEmpty && parts[0].trim() == suffix) {
        return BreachResult(
          isBreached: true,
          occurrenceCount: int.tryParse(parts[1].trim()) ?? 0,
          checkedAt: DateTime.now().toUtc(),
        );
      }
    }

    return BreachResult(
      isBreached: false,
      occurrenceCount: 0,
      checkedAt: DateTime.now().toUtc(),
    );
  }
}
