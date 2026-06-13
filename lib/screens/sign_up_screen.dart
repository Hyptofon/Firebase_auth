import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/widgets/auth/auth_screen_layout.dart';
import 'package:lr16_firebase_auth/widgets/auth/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  final AuthCredentialsRepository authRepository;

  const SignUpScreen({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.signUpAppBar)),
      body: AnimatedAuthContent(
        child: AuthScreenLayout(
          mobileTopSpacing: 16,
          child: SignUpForm(
            authRepository: authRepository,
            onLogin: () => _close(context),
            onAccountCreated: () => _close(context),
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }
}
