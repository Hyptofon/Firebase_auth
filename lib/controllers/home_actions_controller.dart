import '../models/auth_result.dart';
import '../repositories/auth_repository.dart';

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
        message: 'No user is currently signed in.',
        code: 'no-user',
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
