import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/utils/snack_bar_helper.dart';
import 'package:lr16_firebase_auth/utils/validators.dart';
import 'package:lr16_firebase_auth/widgets/app_button.dart';
import 'package:lr16_firebase_auth/widgets/app_text_field.dart';

class SignUpForm extends StatefulWidget {
  final AuthCredentialsRepository authRepository;
  final VoidCallback onLogin;
  final VoidCallback onAccountCreated;

  const SignUpForm({
    super.key,
    required this.authRepository,
    required this.onLogin,
    required this.onAccountCreated,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _hasSubmitted = false;
  bool _canSubmit = false;

  AutovalidateMode get _autovalidateMode => _hasSubmitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateCanSubmit);
    _emailController.addListener(_updateCanSubmit);
    _passwordController.addListener(_updateCanSubmit);
    _confirmPasswordController.addListener(_updateCanSubmit);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateCanSubmit);
    _emailController.removeListener(_updateCanSubmit);
    _passwordController.removeListener(_updateCanSubmit);
    _confirmPasswordController.removeListener(_updateCanSubmit);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_canSubmit || _isLoading) return;

    setState(() => _hasSubmitted = true);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await widget.authRepository.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case AuthSuccess():
        context.showSuccessSnackBar(AuthStrings.signUpSuccess);
        widget.onAccountCreated();
        break;
      case AuthMessageSuccess():
        break;
      case AuthFailure(:final message):
        context.showErrorSnackBar(message);
        break;
    }
  }

  void _updateCanSubmit() {
    final canSubmit =
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

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
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_outlined,
              size: 36,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AuthStrings.signUpTitle,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AuthStrings.signUpSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppTextField(
            controller: _nameController,
            labelText: AuthStrings.nameLabel,
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            validator: Validators.compose([
              (v) =>
                  Validators.required(v, fieldName: AuthStrings.nameFieldName),
              Validators.name,
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 16),
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
            textInputAction: TextInputAction.next,
            // Validators.password now validates non-empty itself
            // - no need to compose with required().
            validator: Validators.password,
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _confirmPasswordController,
            labelText: AuthStrings.confirmPasswordLabel,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _signUp(),
            validator: Validators.compose([
              (v) => Validators.required(
                v,
                fieldName: AuthStrings.confirmPasswordLabel,
              ),
              Validators.confirmPassword(() => _passwordController.text),
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 32),
          AppPrimaryButton(
            onPressed: _canSubmit ? _signUp : null,
            label: AuthStrings.signUpButton,
            isLoading: _isLoading,
            icon: Icons.person_add,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AuthStrings.alreadyHaveAccount,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: widget.onLogin,
                child: Text(
                  AuthStrings.loginButton,
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
