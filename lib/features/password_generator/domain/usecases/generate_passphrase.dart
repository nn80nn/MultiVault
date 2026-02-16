import 'dart:math';

import '../../data/diceware_wordlist.dart';

class GeneratePassphrase {
  String call({
    int wordCount = 5,
    String separator = '-',
    bool capitalize = true,
  }) {
    if (wordCount < 3 || wordCount > 10) {
      throw ArgumentError('Word count must be between 3 and 10');
    }

    final random = Random.secure();
    final words = List.generate(wordCount, (_) {
      final index = random.nextInt(DicewareWordlist.words.length);
      var word = DicewareWordlist.words[index];
      if (capitalize) {
        word = word[0].toUpperCase() + word.substring(1);
      }
      return word;
    });

    return words.join(separator);
  }
}
