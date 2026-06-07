class FirebaseErrorMapper {
  const FirebaseErrorMapper();

  String mapError(String code) {
    return switch (code) {
      'weak-password' => 'The password is too weak. Use at least 6 characters.',
      'email-already-in-use' =>
        'An account already exists with this email address.',
      'invalid-email' => 'The email address is not valid.',
      'user-not-found' =>
        'Unable to sign in. Check your email and password, or create an account.',
      'wrong-password' =>
        'Unable to sign in. Check your email and password, or create an account.',
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'operation-not-allowed' => 'This sign-in method is not enabled.',
      'network-request-failed' =>
        'Network error. Check your internet connection.',
      'invalid-credential' =>
        'Unable to sign in. Check your email and password, or create an account.',
      'requires-recent-login' =>
        'Please sign in again before performing this action.',
      'credential-already-in-use' =>
        'This credential is already associated with another account.',
      _ => 'An error occurred ($code). Please try again.',
    };
  }
}
