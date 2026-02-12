class AppConstants {
  AppConstants._();

  // PBKDF2
  static const int pbkdf2Iterations = 600000;
  static const int keyLength = 32; // 256 bits
  static const int saltLength = 32;
  static const int ivLength = 16; // AES block size

  // Auto-lock
  static const int defaultAutoLockSeconds = 300; // 5 minutes
  static const int defaultClipboardClearSeconds = 30;

  // Password generator
  static const int defaultPasswordLength = 16;
  static const int minPasswordLength = 4;
  static const int maxPasswordLength = 128;

  // Master password requirements
  static const int minMasterPasswordLength = 12;

  // Secure storage keys
  static const String ssSalt = 'mv_salt';
  static const String ssVerifyHash = 'mv_verify_hash';
  static const String ssIterations = 'mv_iterations';
  static const String ssBioKey = 'mv_bio_key';
  static const String ssDbKey = 'mv_db_key';
  static const String ssMasterConfigured = 'mv_master_configured';

  // Failed login
  static const int maxFailedAttempts = 5;
  static const int lockoutDurationSeconds = 30;
}
