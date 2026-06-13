import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';

class HomeActionsController {
  final AuthCredentialsRepository authCredentialsRepository;
  final AccountRepository accountRepository;
  final AuthStateRepository authStateRepository;

  const HomeActionsController({
    required this.authCredentialsRepository,
    required this.accountRepository,
    required this.authStateRepository,
  });

  Future<AuthResult> logout() {
    return authCredentialsRepository.signOut();
  }

  Future<AuthResult> sendVerificationEmail() {
    return accountRepository.sendEmailVerification();
  }

  Future<AuthResult> updateDisplayName(String displayName) {
    return accountRepository.updateDisplayName(displayName: displayName);
  }

  Future<AuthResult> deleteAccount(String password) async {
    final email = authStateRepository.currentEmail;
    if (email == null) {
      return const AuthFailure(
        message: AuthStrings.noUserError,
        code: AuthStrings.noUserCode,
      );
    }

    final reauthResult = await accountRepository.reauthenticate(
      email: email,
      password: password,
    );

    switch (reauthResult) {
      case AuthSuccess():
      case AuthMessageSuccess():
        return accountRepository.deleteAccount();
      case AuthFailure():
        return reauthResult;
    }
  }
}
