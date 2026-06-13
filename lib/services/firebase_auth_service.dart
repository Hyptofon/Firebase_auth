import 'package:firebase_auth/firebase_auth.dart';
import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/utils/firebase_error_mapper.dart';

class FirebaseAuthService implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseErrorMapper _errorMapper;

  static const AuthFailure _noUserError = AuthFailure(
    message: AuthStrings.noUserError,
    code: AuthStrings.noUserCode,
  );

  FirebaseAuthService({FirebaseAuth? auth, FirebaseErrorMapper? errorMapper})
    : _auth = auth ?? FirebaseAuth.instance,
      _errorMapper = errorMapper ?? const FirebaseErrorMapper();

  Future<AuthResult> _withCurrentUser(
    Future<AuthResult> Function(User user) action,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return _noUserError;
      return await action(user);
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  String? get currentDisplayName => _auth.currentUser?.displayName;

  @override
  String? get currentEmail => _auth.currentUser?.email;

  @override
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return const AuthFailure(
          message: AuthStrings.createAccountFailed,
          code: AuthStrings.unknownErrorCode,
        );
      }

      if (displayName != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
        await user.reload();
      }

      return _buildAuthSuccess();
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        return const AuthFailure(
          message: AuthStrings.signInFailed,
          code: AuthStrings.unknownErrorCode,
        );
      }

      return _buildAuthSuccess();
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      await _auth.signOut();
      return const AuthMessageSuccess(message: AuthStrings.signOutSuccess);
    } catch (e) {
      return AuthFailure(
        message: '${AuthStrings.signOutFailedPrefix}$e',
        code: AuthStrings.signOutFailedCode,
      );
    }
  }

  @override
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthMessageSuccess(
        message: AuthStrings.passwordResetEmailSent,
      );
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> sendEmailVerification() => _withCurrentUser((user) async {
    if (user.emailVerified) {
      return const AuthMessageSuccess(
        message: AuthStrings.emailAlreadyVerified,
      );
    }

    await user.sendEmailVerification();
    return const AuthMessageSuccess(message: AuthStrings.verificationEmailSent);
  });

  @override
  Future<AuthResult> updateDisplayName({required String displayName}) =>
      _withCurrentUser((user) async {
        await user.updateDisplayName(displayName.trim());
        await user.reload();
        return _buildAuthSuccess();
      });

  @override
  Future<AuthResult> deleteAccount() => _withCurrentUser((user) async {
    await user.delete();
    return const AuthMessageSuccess(message: AuthStrings.accountDeletedSuccess);
  });

  @override
  Future<AuthResult> reauthenticate({
    required String email,
    required String password,
  }) => _withCurrentUser((user) async {
    final credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    return _buildAuthSuccess();
  });

  AuthSuccess _buildAuthSuccess() {
    final user = _auth.currentUser;
    return AuthSuccess(
      displayName: user?.displayName,
      email: user?.email,
      emailVerified: user?.emailVerified ?? false,
    );
  }

  AuthFailure _mapException(FirebaseAuthException e) {
    return AuthFailure(message: _errorMapper.mapError(e.code), code: e.code);
  }

  AuthFailure _mapUnknownError(Object e) {
    return AuthFailure(
      message: '${AuthStrings.unexpectedErrorPrefix}$e',
      code: AuthStrings.unknownErrorCode,
    );
  }
}
