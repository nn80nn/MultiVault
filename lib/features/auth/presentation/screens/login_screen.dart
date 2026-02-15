import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../services/device_security_service.dart';
import '../widgets/biometric_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  int _failedAttempts = 0;
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _checkDeviceSecurity();
  }

  /// Checks if device is compromised and shows warning
  /// SECURITY: Does not block access - only warns user
  Future<void> _checkDeviceSecurity() async {
    try {
      final deviceSecurityService = ref.read(deviceSecurityServiceProvider);
      final status = await deviceSecurityService.getSecurityStatus();

      if (status.isCompromised && mounted) {
        // Show warning after a short delay to not interfere with screen initialization
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showSecurityWarning(status, deviceSecurityService);
          }
        });
      }
    } catch (e) {
      // Silently fail - don't block user access if check fails
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final biometricService = ref.read(biometricServiceProvider);
      final authRepository = ref.read(authRepositoryProvider);
      final settingsRepository = ref.read(settingsRepositoryProvider);

      // Check 1: Hardware support
      final isAvailable = await biometricService.isBiometricAvailable();
      final biometrics = await biometricService.getAvailableBiometrics();

      if (!isAvailable || biometrics.isEmpty) {
        if (mounted) {
          setState(() {
            _isBiometricAvailable = false;
            _availableBiometrics = [];
          });
        }
        return;
      }

      // Check 2: Biometrics enabled in app settings
      final settings = await settingsRepository.getSettings();
      if (!settings.biometricsEnabled) {
        if (mounted) {
          setState(() {
            _isBiometricAvailable = false;
            _availableBiometrics = biometrics;
          });
        }
        return;
      }

      // Check 3: Biometric key exists in secure storage
      final storedKey = await authRepository.getBiometricKey();
      if (storedKey == null) {
        if (mounted) {
          setState(() {
            _isBiometricAvailable = false;
            _availableBiometrics = biometrics;
          });
        }
        return;
      }

      // All checks pass
      if (mounted) {
        setState(() {
          _isBiometricAvailable = true;
          _availableBiometrics = biometrics;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
          _availableBiometrics = [];
        });
      }
    }
  }

  Future<void> _handlePasswordLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      // Verify master password - returns derivedKey or null
      final derivedKey = await authRepository.verifyMasterPassword(
        _passwordController.text,
      );

      if (derivedKey == null) {
        setState(() {
          _failedAttempts++;
          _isLoading = false;
        });

        if (mounted) {
          context.showSnackBar(
            'Incorrect password. Attempt $_failedAttempts of 5',
            isError: true,
          );
        }

        // Lock out after 5 failed attempts
        if (_failedAttempts >= 5) {
          if (mounted) {
            context.showSnackBar(
              'Too many failed attempts. Please try again later.',
              isError: true,
            );
          }
          await Future.delayed(const Duration(seconds: 30));
          if (mounted) {
            setState(() => _failedAttempts = 0);
          }
        }
        return;
      }

      // Set encryption key and unlock vault
      ref.read(encryptionKeyProvider.notifier).state = derivedKey;
      ref.read(lockStatusProvider.notifier).state = LockStatus.unlocked;

      // Reset failed attempts
      setState(() => _failedAttempts = 0);

      if (mounted) {
        context.showSnackBar('Welcome back!');
        // The GoRouter will automatically redirect based on lock status
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Login failed: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() => _isLoading = true);

    try {
      final biometricService = ref.read(biometricServiceProvider);
      final authRepository = ref.read(authRepositoryProvider);

      // Authenticate with biometrics
      final isAuthenticated = await biometricService.authenticate(
        reason: 'Authenticate to unlock your vault',
      );

      if (!isAuthenticated) {
        if (mounted) {
          context.showSnackBar('Biometric authentication failed', isError: true);
        }
        setState(() => _isLoading = false);
        return;
      }

      // Get stored encryption key
      final storedKey = await authRepository.getBiometricKey();

      if (storedKey == null) {
        if (mounted) {
          context.showSnackBar(
            'No stored key found. Please use master password.',
            isError: true,
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Set encryption key and unlock vault
      ref.read(encryptionKeyProvider.notifier).state = storedKey;
      ref.read(lockStatusProvider.notifier).state = LockStatus.unlocked;

      // Reset failed attempts
      setState(() => _failedAttempts = 0);

      if (mounted) {
        context.showSnackBar('Welcome back!');
        // The GoRouter will automatically redirect based on lock status
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Biometric login failed: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Shows warning dialog for compromised devices
  /// SECURITY: Only warns - does not block access for usability
  void _showSecurityWarning(
    DeviceSecurityStatus status,
    DeviceSecurityService service,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.security,
          size: 64,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text('Device Security Warning'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.getWarningMessage(status),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text('Security Implications:'),
            const SizedBox(height: 8),
            const Text('• Apps with root access can read vault data from memory'),
            const Text('• Secure storage may be compromised'),
            const Text('• Debugging tools can extract encryption keys'),
            const Text('• SSL pinning can be bypassed'),
            const SizedBox(height: 16),
            Text(
              'Using a password manager on a compromised device is NOT recommended.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo
                  Icon(
                    Icons.shield_outlined,
                    size: 120,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Welcome back',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Enter your master password to unlock',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Failed Attempts Warning
                  if (_failedAttempts > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Failed attempts: $_failedAttempts of 5',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: 'Master Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your master password';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handlePasswordLogin(),
                  ),
                  const SizedBox(height: 24),

                  // Unlock Button
                  FilledButton(
                    onPressed: _isLoading ? null : _handlePasswordLogin,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Unlock'),
                  ),

                  // Biometric Option
                  if (_isBiometricAvailable) ...[
                    const SizedBox(height: 24),

                    // Divider with "or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Biometric Button
                    Center(
                      child: Column(
                        children: [
                          BiometricButton(
                            availableBiometrics: _availableBiometrics,
                            onPressed: _isLoading ? null : _handleBiometricLogin,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _availableBiometrics.contains(BiometricType.face)
                                ? 'Unlock with Face ID'
                                : _availableBiometrics.contains(BiometricType.fingerprint)
                                    ? 'Unlock with Fingerprint'
                                    : 'Unlock with Biometrics',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Forgot Password Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'If you forgot your master password, you will need to '
                            'reset the app and lose all stored data.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
