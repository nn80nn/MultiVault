import 'dart:io';

import 'package:flutter_windowmanager/flutter_windowmanager.dart';

/// Service to manage screen security (prevent screenshots and screen recording)
class ScreenSecurityService {
  /// Enable screen security (FLAG_SECURE on Android)
  /// Prevents screenshots, screen recording, and appearing in recent apps
  Future<void> enableScreenSecurity() async {
    if (Platform.isAndroid) {
      try {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
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
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      } catch (e) {
        // Silently fail
      }
    }
  }
}
