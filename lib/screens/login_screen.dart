import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/screens/forgot_password_screen.dart';
import 'package:lr16_firebase_auth/screens/sign_up_screen.dart';
import 'package:lr16_firebase_auth/widgets/auth/auth_screen_layout.dart';
import 'package:lr16_firebase_auth/widgets/auth/login_form.dart';

class LoginScreen extends StatelessWidget {
  final AuthCredentialsRepository authRepository;

  const LoginScreen({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedAuthContent(
        duration: const Duration(milliseconds: 800),
        beginOffset: const Offset(0, 0.1),
        child: AuthScreenLayout(
          mobileTopSpacing: 60,
          child: LoginForm(
            authRepository: authRepository,
            onSignUp: () => _navigateToSignUp(context),
            onForgotPassword: () => _navigateToForgotPassword(context),
          ),
        ),
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpScreen(authRepository: authRepository),
      ),
    );
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(authRepository: authRepository),
      ),
    );
  }
}
