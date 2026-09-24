import '../constants/app_constants.dart';

/// Centralized form validators.
///
/// Every validator returns `null` when the input is valid, or a short,
/// user-friendly error message otherwise — safe to pass straight into a
/// [TextFormField]'s `validator`.
class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$',
  );

  // Accepts optional leading +, 7-15 digits — deliberately loose since
  // phone formats vary a lot by country.
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, fieldName: 'Email');
    if (requiredError != null) return requiredError;

    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value, fieldName: 'Password');
    if (requiredError != null) return requiredError;

    if (value!.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    final requiredError = required(value, fieldName: 'Confirm password');
    if (requiredError != null) return requiredError;

    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? phone(String? value) {
    final requiredError = required(value, fieldName: 'Phone number');
    if (requiredError != null) return requiredError;

    final cleaned = value!.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegex.hasMatch(cleaned)) {
      return 'Enter a valid phone number.';
    }
    return null;
  }

  static String? fullName(String? value) {
    final requiredError = required(value, fieldName: 'Full name');
    if (requiredError != null) return requiredError;

    if (value!.trim().length > AppConstants.maxFullNameLength) {
      return 'Name is too long.';
    }
    if (!value.trim().contains(' ')) {
      return 'Enter your full name.';
    }
    return null;
  }
}
