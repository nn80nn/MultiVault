import 'package:flutter/services.dart';

class AutofillSettingsService {
  static const _channel = MethodChannel('com.multivault/autofill');

  /// Opens the system autofill settings so the user can select MultiVault
  /// as their autofill provider.
  Future<void> openAutofillSettings() async {
    try {
      await _channel.invokeMethod('openAutofillSettings');
    } on PlatformException {
      // Not supported or failed - silently ignore
    }
  }

  /// Checks if this app is currently the selected autofill provider.
  Future<bool> isAutofillProvider() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAutofillProvider');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
