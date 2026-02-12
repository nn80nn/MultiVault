import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/password_strength.dart';
import '../../../../bootstrap.dart';
import '../widgets/password_strength_indicator.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  PasswordStrength _passwordStrength = PasswordStrength.weak;

  // Password requirements
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordRequirements);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordRequirements() {
    final password = _passwordController.text;

    setState(() {
      _hasMinLength = password.length >= 12;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      _passwordStrength = PasswordStrengthCalculator.evaluate(password);
    });
  }

  bool get _allRequirementsMet =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecialChar;

  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _canSubmit =>
      _allRequirementsMet && _passwordsMatch && !_isLoading;

  Future<void> _handleSetup() async {
    if (!_formKey.currentState!.validate() || !_canSubmit) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final encryptionService = ref.read(encryptionServiceProvider);

      // Setup master password - this stores salt, verifyHash, and dbKey in secure storage
      await authRepository.setupMasterPassword(_passwordController.text);

      // Verify to get derived key
      final derivedKey = await authRepository.verifyMasterPassword(_passwordController.text);
      if (derivedKey == null) {
        throw Exception('Setup failed - could not verify password');
      }

      // Open the encrypted database and set it in the provider
      final db = await openDatabaseAfterSetup(encryptionService, derivedKey);
      ref.read(appDatabaseProvider.notifier).state = db;

      // Set encryption key and unlock status
      ref.read(encryptionKeyProvider.notifier).state = derivedKey;
      ref.read(lockStatusProvider.notifier).state = LockStatus.unlocked;

      if (mounted) {
        context.showSnackBar('Vault created successfully!');
        // The GoRouter will automatically redirect to the vault screen
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to create vault: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                    'Create your master password',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'This password will encrypt and protect all your data',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
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
                        return 'Please enter a password';
                      }
                      if (!_allRequirementsMet) {
                        return 'Password does not meet all requirements';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Strength Indicator
                  PasswordStrengthIndicator(strength: _passwordStrength),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirm = !_obscureConfirm);
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleSetup(),
                  ),
                  const SizedBox(height: 24),

                  // Requirements Checklist
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password Requirements',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRequirementItem(
                          'At least 12 characters',
                          _hasMinLength,
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementItem(
                          'One uppercase letter',
                          _hasUppercase,
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementItem(
                          'One lowercase letter',
                          _hasLowercase,
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementItem(
                          'One number',
                          _hasDigit,
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementItem(
                          'One special character',
                          _hasSpecialChar,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Create Vault Button
                  FilledButton(
                    onPressed: _canSubmit ? _handleSetup : null,
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
                        : const Text('Create Vault'),
                  ),
                  const SizedBox(height: 16),

                  // Warning Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Important: Your master password cannot be recovered. '
                            'Make sure to remember it or store it in a safe place.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onErrorContainer,
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

  Widget _buildRequirementItem(String text, bool isMet) {
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 20,
          color: isMet ? Colors.green : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green : colorScheme.onSurfaceVariant,
            fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
