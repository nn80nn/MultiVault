import 'dart:io';

import 'package:flutter/services.dart';

/// Service to manage screen security (prevent screenshots and screen recording)
/// Uses native platform channel instead of flutter_windowmanager (deprecated V1 embedding)
class ScreenSecurityService {
  static const _channel = MethodChannel('com.multivault/screen_security');

  /// Enable screen security (FLAG_SECURE on Android)
  /// Prevents screenshots, screen recording, and appearing in recent apps
  Future<void> enableScreenSecurity() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('enableSecure');
      } catch (e) {
        // Silently fail if not supported on this device
        // Better to have app work without protection than crash
      }
    }
    // iOS doesn't need this - system already prevents screenshots of secure fields
  }

  /// Disable screen security (for non-sensitive screens)
  Future<void> disableScreenSecurity() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('disableSecure');
      } catch (e) {
        // Silently fail
      }
    }
  }
}
