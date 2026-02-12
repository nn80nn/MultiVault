class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});
  @override
  String toString() => 'AppException($code): $message';
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class CryptoException extends AppException {
  const CryptoException(super.message, {super.code});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

class ImportException extends AppException {
  const ImportException(super.message, {super.code});
}

class ExportException extends AppException {
  const ExportException(super.message, {super.code});
}
