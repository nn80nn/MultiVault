class InputValidators {
  InputValidators._();

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.length > 255) {
      return 'Title must be less than 255 characters';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null || (!uri.hasScheme && !value.contains('.'))) {
      return 'Invalid URL format';
    }
    return null;
  }

  static String? validateMasterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Master password is required';
    }
    if (value.length < 12) {
      return 'Must be at least 12 characters';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain a lowercase letter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain a digit';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/~`]'))) {
      return 'Must contain a special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
