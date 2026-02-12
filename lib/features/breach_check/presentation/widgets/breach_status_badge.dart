import 'package:flutter/material.dart';
import '../../domain/entities/breach_result.dart';

class BreachStatusBadge extends StatelessWidget {
  final BreachResult? breachResult;
  final bool compact;

  const BreachStatusBadge({
    super.key,
    required this.breachResult,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (breachResult == null) {
      return _buildCheckingBadge(theme, colorScheme);
    }

    if (breachResult!.isBreached) {
      return _buildBreachedBadge(theme, colorScheme);
    }

    return _buildSafeBadge(theme, colorScheme);
  }

  Widget _buildCheckingBadge(ThemeData theme, ColorScheme colorScheme) {
    if (compact) {
      return Chip(
        avatar: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        label: const Text('Checking'),
        visualDensity: VisualDensity.compact,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Checking breach status...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeBadge(ThemeData theme, ColorScheme colorScheme) {
    if (compact) {
      return Chip(
        avatar: Icon(
          Icons.check_circle,
          color: Colors.green[700],
          size: 18,
        ),
        label: const Text('Safe'),
        backgroundColor: Colors.green[50],
        side: BorderSide(color: Colors.green[200]!),
        visualDensity: VisualDensity.compact,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'No breaches found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.green[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreachedBadge(ThemeData theme, ColorScheme colorScheme) {
    final count = breachResult!.occurrenceCount;

    if (compact) {
      return Chip(
        avatar: Icon(
          Icons.warning,
          color: Colors.red[700],
          size: 18,
        ),
        label: Text('Breached ($count)'),
        backgroundColor: Colors.red[50],
        side: BorderSide(color: Colors.red[200]!),
        visualDensity: VisualDensity.compact,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning,
            color: Colors.red[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            count == 1
                ? 'Found in 1 breach'
                : 'Found in $count breaches',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.red[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class BreachStatusIndicator extends StatelessWidget {
  final BreachResult? breachResult;

  const BreachStatusIndicator({
    super.key,
    required this.breachResult,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (breachResult == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checking breach status',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comparing against known data breaches...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (breachResult!.isBreached) {
      return Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red[700],
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password Compromised',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Found in ${breachResult!.occurrenceCount} ${breachResult!.occurrenceCount == 1 ? 'breach' : 'breaches'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Change Password'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[700],
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password Safe',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No known breaches found',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
