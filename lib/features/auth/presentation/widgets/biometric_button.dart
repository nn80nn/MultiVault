import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricButton extends StatelessWidget {
  final List<BiometricType> availableBiometrics;
  final VoidCallback? onPressed;

  const BiometricButton({
    super.key,
    required this.availableBiometrics,
    this.onPressed,
  });

  IconData _getIcon() {
    if (availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    }
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    }
    if (availableBiometrics.contains(BiometricType.iris)) {
      return Icons.remove_red_eye_outlined;
    }
    return Icons.fingerprint;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: onPressed == null
          ? colorScheme.surfaceContainerHighest
          : colorScheme.primaryContainer,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Icon(
            _getIcon(),
            size: 48,
            color: onPressed == null
                ? colorScheme.onSurfaceVariant
                : colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
