import 'package:flutter/material.dart';
import '../../models/auth_result.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/snack_bar_helper.dart';
import '../../utils/validators.dart';
import '../app_button.dart';
import '../app_text_field.dart';

class LoginForm extends StatefulWidget {
  final AuthCredentialsRepository authRepository;
  final VoidCallback onSignUp;
  final VoidCallback onForgotPassword;

  const LoginForm({
    super.key,
    required this.authRepository,
    required this.onSignUp,
    required this.onForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _hasSubmitted = false;
  bool _canSubmit = false;

  AutovalidateMode get _autovalidateMode => _hasSubmitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateCanSubmit);
    _passwordController.addListener(_updateCanSubmit);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateCanSubmit);
    _passwordController.removeListener(_updateCanSubmit);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_canSubmit || _isLoading) return;

    setState(() => _hasSubmitted = true);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await widget.authRepository.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case AuthSuccess():
      case AuthMessageSuccess():
        break;
      case AuthFailure(:final message):
        context.showErrorSnackBar(message);
        break;
    }
  }

  void _updateCanSubmit() {
    final canSubmit =
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;

    if (canSubmit == _canSubmit) return;
    setState(() => _canSubmit = canSubmit);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 44,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome Back',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to your account',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.compose([
              (v) => Validators.required(v, fieldName: 'Email'),
              Validators.email,
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _passwordController,
            labelText: 'Password',
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            validator: Validators.compose([
              (v) => Validators.required(v, fieldName: 'Password'),
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            onPressed: _canSubmit ? _login : null,
            label: 'LOGIN',
            isLoading: _isLoading,
            icon: Icons.login,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: widget.onSignUp,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
