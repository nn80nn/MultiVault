import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _settingsKey = 'app_settings';
  final SharedPreferences _prefs;
  final _controller = StreamController<AppSettings>.broadcast();

  SettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<AppSettings> getSettings() async {
    final json = _prefs.getString(_settingsKey);
    if (json == null) return const AppSettings();
    return AppSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    _controller.add(settings);
  }

  @override
  Stream<AppSettings> watchSettings() async* {
    yield await getSettings();
    yield* _controller.stream;
  }
}
