import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../widgets/auth/auth_screen_layout.dart';
import '../widgets/auth/forgot_password_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final AuthCredentialsRepository authRepository;

  const ForgotPasswordScreen({super.key, required this.authRepository});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: AuthScreenLayout(
          mobileTopSpacing: 40,
          child: ForgotPasswordForm(
            authRepository: widget.authRepository,
            onBackToLogin: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
