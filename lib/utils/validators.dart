class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    ).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a required password field.
  ///
  /// Returns an error if [value] is empty OR shorter than 6 characters.
  /// Use [optionalPassword] when the field is not mandatory (e.g. reauthentication
  /// dialogs where the field may be pre-filled by the OS).
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Like [password] but allows an empty value (treats empty as valid).
  /// Use this only for truly optional password fields.
  static String? optionalPassword(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(
    String Function() getPassword,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value != getPassword()) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? Function(String?) maxLength(
    int maxLength, {
    String fieldName = 'This field',
  }) {
    return (String? value) {
      if (value == null || value.length <= maxLength) return null;
      return '$fieldName must be at most $maxLength characters';
    };
  }

  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
