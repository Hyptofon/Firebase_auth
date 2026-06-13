import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/widgets/auth/auth_screen_layout.dart';
import 'package:lr16_firebase_auth/widgets/auth/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthCredentialsRepository authRepository;

  const ForgotPasswordScreen({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.resetPasswordAppBar)),
      body: AnimatedAuthContent(
        child: AuthScreenLayout(
          mobileTopSpacing: 40,
          child: ForgotPasswordForm(
            authRepository: authRepository,
            onBackToLogin: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
