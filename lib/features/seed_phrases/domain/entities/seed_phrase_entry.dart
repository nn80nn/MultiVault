class SeedPhraseEntry {
  final String id;
  final String name;
  final String encryptedPhrase;
  final String? blockchain;
  final String? walletAddress;
  final String? encryptedNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const SeedPhraseEntry({
    required this.id,
    required this.name,
    required this.encryptedPhrase,
    this.blockchain,
    this.walletAddress,
    this.encryptedNotes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  SeedPhraseEntry copyWith({
    String? id,
    String? name,
    String? encryptedPhrase,
    String? blockchain,
    String? walletAddress,
    String? encryptedNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return SeedPhraseEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      encryptedPhrase: encryptedPhrase ?? this.encryptedPhrase,
      blockchain: blockchain ?? this.blockchain,
      walletAddress: walletAddress ?? this.walletAddress,
      encryptedNotes: encryptedNotes ?? this.encryptedNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Validates BIP-39 word count
  static bool isValidWordCount(String phrase) {
    final words = phrase.trim().split(RegExp(r'\s+'));
    return const [12, 15, 18, 21, 24].contains(words.length);
  }

  /// Returns the list of words from the phrase
  static List<String> getWords(String phrase) {
    return phrase.trim().split(RegExp(r'\s+'));
  }
}
