extension StringExtensions on String {
  String get masked => '\u2022' * length;

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  String? get nullIfEmpty => isEmpty ? null : this;
}
