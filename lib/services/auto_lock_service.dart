import 'dart:async';

import 'package:flutter/foundation.dart';

class AutoLockService {
  Timer? _inactivityTimer;
  int _timeoutSeconds;
  final VoidCallback onLock;

  AutoLockService({
    required int timeoutSeconds,
    required this.onLock,
  }) : _timeoutSeconds = timeoutSeconds;

  set timeoutSeconds(int value) {
    _timeoutSeconds = value;
    resetTimer();
  }

  void resetTimer() {
    _inactivityTimer?.cancel();
    if (_timeoutSeconds > 0) {
      _inactivityTimer = Timer(
        Duration(seconds: _timeoutSeconds),
        _triggerLock,
      );
    }
  }

  void _triggerLock() {
    onLock();
  }

  void onAppBackgrounded() {
    _triggerLock();
  }

  void pause() {
    _inactivityTimer?.cancel();
  }

  void dispose() {
    _inactivityTimer?.cancel();
  }
}
