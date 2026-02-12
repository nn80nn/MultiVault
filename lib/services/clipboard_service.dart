import 'dart:async';

import 'package:flutter/services.dart';

class ClipboardService {
  Timer? _clearTimer;
  int _clearAfterSeconds;

  ClipboardService({int clearAfterSeconds = 30})
      : _clearAfterSeconds = clearAfterSeconds;

  set clearAfterSeconds(int value) => _clearAfterSeconds = value;

  Future<void> copyAndScheduleClear(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _clearTimer?.cancel();
    _clearTimer = Timer(Duration(seconds: _clearAfterSeconds), () async {
      await Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  Future<void> clearNow() async {
    _clearTimer?.cancel();
    await Clipboard.setData(const ClipboardData(text: ''));
  }

  void dispose() {
    _clearTimer?.cancel();
  }
}
