import 'package:freezed_annotation/freezed_annotation.dart';

part 'generator_config.freezed.dart';
part 'generator_config.g.dart';

@freezed
class GeneratorConfig with _$GeneratorConfig {
  const factory GeneratorConfig({
    @Default(16) int length,
    @Default(true) bool uppercase,
    @Default(true) bool lowercase,
    @Default(true) bool digits,
    @Default(true) bool symbols,
    @Default('') String excludeCharacters,
  }) = _GeneratorConfig;

  factory GeneratorConfig.fromJson(Map<String, dynamic> json) =>
      _$GeneratorConfigFromJson(json);
}
