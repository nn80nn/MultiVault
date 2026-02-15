import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

/// Service for detecting compromised devices (rooted/jailbroken)
///
/// SECURITY: Rooted/jailbroken devices are inherently insecure:
/// - Other apps with root can read app memory
/// - Secure storage can be compromised
/// - SSL pinning can be bypassed
/// - Debugging tools can extract encryption keys
class DeviceSecurityService {
  bool? _isJailbroken;
  bool? _isDeveloperMode;

  /// Checks if device is jailbroken (iOS) or rooted (Android)
  Future<bool> isDeviceCompromised() async {
    try {
      _isJailbroken = await FlutterJailbreakDetection.jailbroken;
      _isDeveloperMode = await FlutterJailbreakDetection.developerMode;

      // Device is compromised if jailbroken/rooted OR developer mode is enabled
      return _isJailbroken == true || _isDeveloperMode == true;
    } catch (e) {
      // If detection fails, assume device is safe (fail-open for usability)
      // Better to allow usage than lock out legitimate users
      return false;
    }
  }

  /// Returns detailed security status
  Future<DeviceSecurityStatus> getSecurityStatus() async {
    final isCompromised = await isDeviceCompromised();

    return DeviceSecurityStatus(
      isJailbroken: _isJailbroken ?? false,
      isDeveloperMode: _isDeveloperMode ?? false,
      isCompromised: isCompromised,
    );
  }

  /// Gets a user-friendly warning message
  String getWarningMessage(DeviceSecurityStatus status) {
    if (status.isJailbroken && status.isDeveloperMode) {
      return 'Your device is rooted/jailbroken AND has developer mode enabled. '
          'This significantly increases security risks.';
    } else if (status.isJailbroken) {
      return 'Your device appears to be rooted (Android) or jailbroken (iOS). '
          'Other apps with elevated privileges may be able to access your vault data.';
    } else if (status.isDeveloperMode) {
      return 'Developer mode is enabled on your device. '
          'This may allow debugging tools to access sensitive data.';
    }
    return 'Your device security status could not be determined.';
  }
}

class DeviceSecurityStatus {
  final bool isJailbroken;
  final bool isDeveloperMode;
  final bool isCompromised;

  DeviceSecurityStatus({
    required this.isJailbroken,
    required this.isDeveloperMode,
    required this.isCompromised,
  });
}
