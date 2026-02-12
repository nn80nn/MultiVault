import 'package:freezed_annotation/freezed_annotation.dart';

part 'breach_result.freezed.dart';
part 'breach_result.g.dart';

@freezed
class BreachResult with _$BreachResult {
  const factory BreachResult({
    required bool isBreached,
    required int occurrenceCount,
    required DateTime checkedAt,
  }) = _BreachResult;

  factory BreachResult.fromJson(Map<String, dynamic> json) =>
      _$BreachResultFromJson(json);
}
