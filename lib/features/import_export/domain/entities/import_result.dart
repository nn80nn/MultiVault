import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_result.freezed.dart';
part 'import_result.g.dart';

@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    required int totalParsed,
    required int successfullyImported,
    required int skippedDuplicates,
    required List<String> errors,
    required String sourceFormat,
    required DateTime importedAt,
  }) = _ImportResult;

  factory ImportResult.fromJson(Map<String, dynamic> json) =>
      _$ImportResultFromJson(json);
}
