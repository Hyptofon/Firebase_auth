import 'package:lr16_firebase_auth/constants/firebase_error_strings.dart';

class FirebaseErrorMapper {
  const FirebaseErrorMapper();

  String mapError(String code) {
    return switch (code) {
      // -- Sign-up errors --------------------------------------------------
      'weak-password' => FirebaseErrorStrings.weakPassword,
      'email-already-in-use' => FirebaseErrorStrings.emailAlreadyInUse,

      // -- Sign-in errors --------------------------------------------------
      'user-not-found' => FirebaseErrorStrings.unableToSignIn,
      'wrong-password' => FirebaseErrorStrings.unableToSignIn,
      // Firebase v9+ combines user-not-found + wrong-password into one code.
      'invalid-credential' => FirebaseErrorStrings.unableToSignIn,
      // Legacy code kept for older SDK versions.
      'email-not-found' => FirebaseErrorStrings.unableToSignIn,

      // -- Common errors ---------------------------------------------------
      'invalid-email' => FirebaseErrorStrings.invalidEmail,
      'user-disabled' => FirebaseErrorStrings.userDisabled,
      'too-many-requests' => FirebaseErrorStrings.tooManyRequests,
      'operation-not-allowed' => FirebaseErrorStrings.operationNotAllowed,
      'network-request-failed' => FirebaseErrorStrings.networkRequestFailed,

      // -- Account management errors ---------------------------------------
      'requires-recent-login' => FirebaseErrorStrings.requiresRecentLogin,
      'credential-already-in-use' =>
        FirebaseErrorStrings.credentialAlreadyInUse,
      // Raised when a user tries to link a provider that is already linked to
      // a different account.
      'account-exists-with-different-credential' =>
        FirebaseErrorStrings.credentialAlreadyInUse,

      // -- Default ---------------------------------------------------------
      _ => FirebaseErrorStrings.genericError(code),
    };
  }
}
