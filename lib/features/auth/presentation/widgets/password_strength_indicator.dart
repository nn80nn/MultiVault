import 'package:flutter/material.dart';
import '../../../../core/utils/password_strength.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  Color _getColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.fair:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  String _getLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  double _getProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(strength);
    final label = _getLabel(strength);
    final progress = _getProgress(strength);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
