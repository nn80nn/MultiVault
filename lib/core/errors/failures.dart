import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CryptoFailure extends Failure {
  const CryptoFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class ImportFailure extends Failure {
  const ImportFailure(super.message);
}

class ExportFailure extends Failure {
  const ExportFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
