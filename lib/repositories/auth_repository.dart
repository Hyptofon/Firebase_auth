import '../models/auth_result.dart';

abstract class AuthStateRepository {
  Stream<bool> get authStateChanges;

  bool get isSignedIn;

  String? get currentDisplayName;

  String? get currentEmail;

  bool get isEmailVerified;
}

abstract class AuthCredentialsRepository {
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  Future<AuthResult> signIn({required String email, required String password});

  Future<AuthResult> signOut();

  Future<AuthResult> sendPasswordResetEmail({required String email});
}

abstract class AccountRepository {
  Future<AuthResult> sendEmailVerification();

  Future<AuthResult> updateDisplayName({required String displayName});

  Future<AuthResult> deleteAccount();

  Future<AuthResult> reauthenticate({
    required String email,
    required String password,
  });
}

abstract class AuthRepository
    implements
        AuthStateRepository,
        AuthCredentialsRepository,
        AccountRepository {}
