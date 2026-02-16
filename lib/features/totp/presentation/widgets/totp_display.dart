import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../domain/usecases/generate_totp.dart';

class TotpDisplay extends StatefulWidget {
  final String secret;

  const TotpDisplay({super.key, required this.secret});

  @override
  State<TotpDisplay> createState() => _TotpDisplayState();
}

class _TotpDisplayState extends State<TotpDisplay> {
  final _generateTotp = GenerateTotp();
  String _code = '';
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateCode();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateCode() {
    final code = _generateTotp(widget.secret);
    setState(() {
      _code = code ?? '------';
      _secondsRemaining = _generateTotp.secondsRemaining();
    });
  }

  void _tick() {
    final remaining = _generateTotp.secondsRemaining();
    if (remaining > _secondsRemaining) {
      // Rolled over to new period
      _generateCode();
    } else {
      setState(() => _secondsRemaining = remaining);
    }
  }

  void _copyCode() {
    if (_code.isNotEmpty && _code != '------') {
      Clipboard.setData(ClipboardData(text: _code));
      context.showSnackBar('TOTP code copied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = _secondsRemaining / 30.0;
    final isExpiring = _secondsRemaining <= 5;

    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer,
      child: InkWell(
        onTap: _copyCode,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Countdown circle
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      backgroundColor:
                          colorScheme.onSecondaryContainer.withValues(alpha: 0.2),
                      color: isExpiring
                          ? colorScheme.error
                          : colorScheme.onSecondaryContainer,
                    ),
                    Text(
                      '$_secondsRemaining',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isExpiring
                            ? colorScheme.error
                            : colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Code display
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2FA Code',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCode(_code),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              // Copy button
              IconButton(
                icon: Icon(
                  Icons.copy,
                  color: colorScheme.onSecondaryContainer,
                ),
                onPressed: _copyCode,
                tooltip: 'Copy code',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format code as "123 456" for readability
  String _formatCode(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    }
    return code;
  }
}
