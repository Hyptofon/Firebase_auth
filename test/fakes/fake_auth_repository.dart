import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final bool signedIn;
  final String? displayName;
  final String? email;
  final bool emailVerified;

  const FakeAuthRepository({
    required this.signedIn,
    this.displayName,
    this.email,
    this.emailVerified = false,
  });

  @override
  Stream<bool> get authStateChanges => Stream<bool>.value(signedIn);

  @override
  bool get isSignedIn => signedIn;

  @override
  String? get currentDisplayName => displayName;

  @override
  String? get currentEmail => email;

  @override
  bool get isEmailVerified => emailVerified;

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return AuthSuccess(displayName: displayName, email: email);
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    return AuthSuccess(displayName: displayName, email: email);
  }

  @override
  Future<AuthResult> signOut() async {
    return const AuthMessageSuccess(message: 'Signed out successfully');
  }

  @override
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    return const AuthMessageSuccess(message: 'Password reset email sent');
  }

  @override
  Future<AuthResult> sendEmailVerification() async {
    return const AuthMessageSuccess(message: 'Verification email sent');
  }

  @override
  Future<AuthResult> updateDisplayName({required String displayName}) async {
    return AuthSuccess(displayName: displayName, email: email);
  }

  @override
  Future<AuthResult> deleteAccount() async {
    return const AuthMessageSuccess(message: 'Account deleted successfully');
  }

  @override
  Future<AuthResult> reauthenticate({
    required String email,
    required String password,
  }) async {
    return AuthSuccess(displayName: displayName, email: email);
  }
}
