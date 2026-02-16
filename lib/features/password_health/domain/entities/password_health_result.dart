import '../../../vault/domain/entities/password_entry.dart';

enum HealthIssueType { weak, reused, old }

class HealthIssue {
  final PasswordEntry entry;
  final HealthIssueType type;
  final String description;

  const HealthIssue({
    required this.entry,
    required this.type,
    required this.description,
  });
}

class PasswordHealthResult {
  final List<HealthIssue> weakPasswords;
  final List<HealthIssue> reusedPasswords;
  final List<HealthIssue> oldPasswords;
  final int totalEntries;

  const PasswordHealthResult({
    required this.weakPasswords,
    required this.reusedPasswords,
    required this.oldPasswords,
    required this.totalEntries,
  });

  int get totalIssues =>
      weakPasswords.length + reusedPasswords.length + oldPasswords.length;

  /// Score 0-100, higher is better
  int get score {
    if (totalEntries == 0) return 100;
    // Each issue type can reduce score by up to 33 points
    final weakRatio = weakPasswords.length / totalEntries;
    final reusedRatio = reusedPasswords.length / totalEntries;
    final oldRatio = oldPasswords.length / totalEntries;
    final deduction = (weakRatio * 40 + reusedRatio * 35 + oldRatio * 25) * 100;
    return (100 - deduction).clamp(0, 100).round();
  }
}
