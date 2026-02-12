import 'dart:math';

import '../entities/generator_config.dart';

class GeneratePassword {
  static const _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _lower = 'abcdefghijklmnopqrstuvwxyz';
  static const _digits = '0123456789';
  static const _symbols = r'!@#$%^&*()_+-=[]{}|;:,.<>?';

  String call(GeneratorConfig config) {
    var charset = '';
    final required = <String>[];

    if (config.uppercase) {
      final filtered = _removeExcluded(_upper, config.excludeCharacters);
      charset += filtered;
      if (filtered.isNotEmpty) required.add(_pickRandom(filtered));
    }
    if (config.lowercase) {
      final filtered = _removeExcluded(_lower, config.excludeCharacters);
      charset += filtered;
      if (filtered.isNotEmpty) required.add(_pickRandom(filtered));
    }
    if (config.digits) {
      final filtered = _removeExcluded(_digits, config.excludeCharacters);
      charset += filtered;
      if (filtered.isNotEmpty) required.add(_pickRandom(filtered));
    }
    if (config.symbols) {
      final filtered = _removeExcluded(_symbols, config.excludeCharacters);
      charset += filtered;
      if (filtered.isNotEmpty) required.add(_pickRandom(filtered));
    }

    if (charset.isEmpty) {
      throw ArgumentError('No characters available for password generation');
    }

    final random = Random.secure();
    final remaining = config.length - required.length;
    final password = List<String>.from(required);

    for (var i = 0; i < remaining; i++) {
      password.add(charset[random.nextInt(charset.length)]);
    }

    password.shuffle(random);
    return password.join();
  }

  String _removeExcluded(String chars, String excluded) {
    if (excluded.isEmpty) return chars;
    return chars.split('').where((c) => !excluded.contains(c)).join();
  }

  String _pickRandom(String chars) {
    final random = Random.secure();
    return chars[random.nextInt(chars.length)];
  }
}
