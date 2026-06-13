import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/utils/snack_bar_helper.dart';
import 'package:lr16_firebase_auth/utils/validators.dart';
import 'package:lr16_firebase_auth/widgets/app_button.dart';
import 'package:lr16_firebase_auth/widgets/app_text_field.dart';

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
            AuthStrings.loginTitle,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AuthStrings.loginSubtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          AppTextField(
            controller: _emailController,
            labelText: AuthStrings.emailLabel,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.compose([
              (v) =>
                  Validators.required(v, fieldName: AuthStrings.emailFieldName),
              Validators.email,
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _passwordController,
            labelText: AuthStrings.passwordLabel,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            // In login, the password field only needs to be non-empty;
            // Validators.password handles that check directly.
            validator: Validators.password,
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: Text(
                AuthStrings.forgotPassword,
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
            label: AuthStrings.loginButton,
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
                  AuthStrings.orDivider,
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
                AuthStrings.noAccount,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: widget.onSignUp,
                child: Text(
                  AuthStrings.signUpButton,
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
