import '../../domain/entities/breach_result.dart';
import '../../domain/repositories/breach_check_repository.dart';
import '../datasources/hibp_api_datasource.dart';

class BreachCheckRepositoryImpl implements BreachCheckRepository {
  final HibpApiDatasource _datasource;

  BreachCheckRepositoryImpl({required HibpApiDatasource datasource})
      : _datasource = datasource;

  @override
  Future<BreachResult> checkPassword(String plainPassword) {
    return _datasource.checkPassword(plainPassword);
  }
}
