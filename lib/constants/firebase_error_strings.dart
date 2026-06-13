class FirebaseErrorStrings {
  FirebaseErrorStrings._();

  static const weakPassword =
      'The password is too weak. Use at least 6 characters.';
  static const emailAlreadyInUse =
      'An account already exists with this email address.';
  static const invalidEmail = 'The email address is not valid.';
  static const unableToSignIn =
      'Unable to sign in. Check your email and password, or create an account.';
  static const userDisabled = 'This account has been disabled.';
  static const tooManyRequests = 'Too many attempts. Please try again later.';
  static const operationNotAllowed = 'This sign-in method is not enabled.';
  static const networkRequestFailed =
      'Network error. Check your internet connection.';
  static const requiresRecentLogin =
      'Please sign in again before performing this action.';
  static const credentialAlreadyInUse =
      'This credential is already associated with another account.';

  static String genericError(String code) =>
      'An error occurred ($code). Please try again.';
}
