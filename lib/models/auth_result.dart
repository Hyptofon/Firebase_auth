sealed class AuthResult {
  const AuthResult();
}

final class AuthSuccess extends AuthResult {
  final String? displayName;
  final String? email;
  final bool emailVerified;

  const AuthSuccess({this.displayName, this.email, this.emailVerified = false});
}

final class AuthMessageSuccess extends AuthResult {
  final String message;
  const AuthMessageSuccess({required this.message});
}

final class AuthFailure extends AuthResult {
  final String message;
  final String code;
  const AuthFailure({required this.message, required this.code});
}
