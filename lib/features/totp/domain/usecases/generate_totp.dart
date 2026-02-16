import 'package:otp/otp.dart';

class GenerateTotp {
  /// Generates a TOTP code from a base32-encoded secret.
  /// Returns null if the secret is invalid.
  String? call(String secret, {int length = 6, int interval = 30}) {
    try {
      final cleanSecret = secret.replaceAll(RegExp(r'\s+'), '').toUpperCase();
      final code = OTP.generateTOTPCodeString(
        cleanSecret,
        DateTime.now().millisecondsSinceEpoch,
        length: length,
        interval: interval,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      return code;
    } catch (e) {
      return null;
    }
  }

  /// Returns seconds remaining until the current TOTP code expires.
  int secondsRemaining({int interval = 30}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return interval - (now % interval);
  }

  /// Parses an otpauth:// URI and returns the secret.
  /// Format: otpauth://totp/Label?secret=BASE32SECRET&issuer=Issuer
  static String? parseOtpauthUri(String uri) {
    try {
      final parsed = Uri.parse(uri);
      if (parsed.scheme != 'otpauth' || parsed.host != 'totp') {
        return null;
      }
      return parsed.queryParameters['secret'];
    } catch (e) {
      return null;
    }
  }
}
