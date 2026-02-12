import '../entities/breach_result.dart';

abstract class BreachCheckRepository {
  Future<BreachResult> checkPassword(String plainPassword);
}
