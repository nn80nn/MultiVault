import 'dart:math';

enum PasswordStrength { weak, fair, strong, veryStrong }

class PasswordStrengthCalculator {
  PasswordStrengthCalculator._();

  static double calculateEntropy(String password) {
    if (password.isEmpty) return 0;

    int charsetSize = 0;
    if (password.contains(RegExp(r'[a-z]'))) charsetSize += 26;
    if (password.contains(RegExp(r'[A-Z]'))) charsetSize += 26;
    if (password.contains(RegExp(r'[0-9]'))) charsetSize += 10;
    if (password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/~`]'))) {
      charsetSize += 33;
    }

    if (charsetSize == 0) charsetSize = 1;
    return password.length * (log(charsetSize) / log(2));
  }

  static PasswordStrength evaluate(String password) {
    final entropy = calculateEntropy(password);
    if (entropy < 28) return PasswordStrength.weak;
    if (entropy < 50) return PasswordStrength.fair;
    if (entropy < 70) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  static bool meetsRequirements(String password) {
    if (password.length < 12) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/~`]'))) {
      return false;
    }
    return true;
  }

  static Map<String, bool> getRequirementStatus(String password) {
    return {
      'minLength': password.length >= 12,
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasDigit': password.contains(RegExp(r'[0-9]')),
      'hasSymbol':
          password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/~`]')),
    };
  }
}
