import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_config.freezed.dart';
part 'export_config.g.dart';

enum ExportFormat { encryptedJson, plainCsv, plainJson }

@freezed
class ExportConfig with _$ExportConfig {
  const factory ExportConfig({
    required ExportFormat format,
    @Default(true) bool includeHistory,
    @Default(true) bool encrypted,
    String? exportPassword,
  }) = _ExportConfig;

  factory ExportConfig.fromJson(Map<String, dynamic> json) =>
      _$ExportConfigFromJson(json);
}
