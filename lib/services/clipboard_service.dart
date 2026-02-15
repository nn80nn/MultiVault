import 'dart:async';

import 'package:flutter/services.dart';

/// Service for secure clipboard operations
///
/// SECURITY LIMITATIONS:
/// 1. Android Keyboard History:
///    - Many keyboards (Gboard, SwiftKey) maintain clipboard history
///    - This service CANNOT prevent keyboards from saving clipboard data
///    - Android 13+ has setSensitiveContent() but Flutter doesn't expose it yet
///    - Recommendation: Warn users to disable clipboard history in keyboard settings
///
/// 2. Clipboard Managers:
///    - Third-party clipboard managers can still capture data
///    - Auto-clear helps but doesn't prevent initial capture
///
/// 3. Other Apps:
///    - Any app can read clipboard at any time
///    - No permission required on most Android versions
///
/// MITIGATION:
/// - Auto-clear clipboard after configurable timeout (default 30s)
/// - Show snackbar reminder that password was copied
/// - Document limitations in user guide
class ClipboardService {
  Timer? _clearTimer;
  int _clearAfterSeconds;

  ClipboardService({int clearAfterSeconds = 30})
      : _clearAfterSeconds = clearAfterSeconds;

  set clearAfterSeconds(int value) => _clearAfterSeconds = value;

  /// Copies text to clipboard and schedules automatic clearing
  ///
  /// SECURITY WARNING: This does NOT prevent:
  /// - Keyboard clipboard history (Gboard, SwiftKey, etc.)
  /// - Third-party clipboard managers
  /// - Other apps from reading clipboard immediately
  ///
  /// The text will be automatically cleared after [_clearAfterSeconds] seconds,
  /// but data may have already been captured by keyboard/other apps.
  Future<void> copyAndScheduleClear(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    // Cancel any existing timer
    _clearTimer?.cancel();

    // Schedule clipboard clearing
    _clearTimer = Timer(Duration(seconds: _clearAfterSeconds), () async {
      await Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  /// Immediately clears clipboard and cancels any pending auto-clear
  Future<void> clearNow() async {
    _clearTimer?.cancel();
    await Clipboard.setData(const ClipboardData(text: ''));
  }

  void dispose() {
    _clearTimer?.cancel();
  }
}

