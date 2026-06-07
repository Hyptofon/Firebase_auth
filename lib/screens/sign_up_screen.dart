import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../widgets/auth/auth_screen_layout.dart';
import '../widgets/auth/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  final AuthCredentialsRepository authRepository;

  const SignUpScreen({super.key, required this.authRepository});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
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
      appBar: AppBar(title: const Text('Sign Up')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: AuthScreenLayout(
          mobileTopSpacing: 16,
          child: SignUpForm(
            authRepository: widget.authRepository,
            onLogin: _close,
            onAccountCreated: _close,
          ),
        ),
      ),
    );
  }

  void _close() {
    Navigator.pop(context);
  }
}
