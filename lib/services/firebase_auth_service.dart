import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_result.dart';
import '../repositories/auth_repository.dart';
import '../utils/firebase_error_mapper.dart';

class FirebaseAuthService implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseErrorMapper _errorMapper;

  FirebaseAuthService({FirebaseAuth? auth, FirebaseErrorMapper? errorMapper})
    : _auth = auth ?? FirebaseAuth.instance,
      _errorMapper = errorMapper ?? const FirebaseErrorMapper();

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
          message: 'Failed to create account. Please try again.',
          code: 'unknown',
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
          message: 'Failed to sign in. Please try again.',
          code: 'unknown',
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
      return const AuthMessageSuccess(message: 'Signed out successfully');
    } catch (e) {
      return AuthFailure(
        message: 'Failed to sign out: $e',
        code: 'sign-out-failed',
      );
    }
  }

  @override
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthMessageSuccess(
        message: 'Password reset email sent. Check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const AuthFailure(
          message: 'No user is currently signed in.',
          code: 'no-user',
        );
      }

      if (user.emailVerified) {
        return const AuthMessageSuccess(message: 'Email is already verified.');
      }

      await user.sendEmailVerification();
      return const AuthMessageSuccess(
        message: 'Verification email sent. Check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> updateDisplayName({required String displayName}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const AuthFailure(
          message: 'No user is currently signed in.',
          code: 'no-user',
        );
      }

      await user.updateDisplayName(displayName.trim());
      await user.reload();
      return _buildAuthSuccess();
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const AuthFailure(
          message: 'No user is currently signed in.',
          code: 'no-user',
        );
      }

      await user.delete();
      return const AuthMessageSuccess(message: 'Account deleted successfully.');
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

  @override
  Future<AuthResult> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const AuthFailure(
          message: 'No user is currently signed in.',
          code: 'no-user',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return _buildAuthSuccess();
    } on FirebaseAuthException catch (e) {
      return _mapException(e);
    } catch (e) {
      return _mapUnknownError(e);
    }
  }

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
      message: 'An unexpected error occurred: $e',
      code: 'unknown',
    );
  }
}
