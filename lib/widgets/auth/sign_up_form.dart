import 'package:flutter/material.dart';
import '../../models/auth_result.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/snack_bar_helper.dart';
import '../../utils/validators.dart';
import '../app_button.dart';
import '../app_text_field.dart';

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
        context.showSuccessSnackBar('Account created successfully!');
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
            'Create Account',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in the details to get started',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppTextField(
            controller: _nameController,
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            validator: Validators.compose([
              (v) => Validators.required(v, fieldName: 'Name'),
              Validators.name,
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 16),
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
            textInputAction: TextInputAction.next,
            validator: Validators.compose([
              (v) => Validators.required(v, fieldName: 'Password'),
              Validators.password,
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _signUp(),
            validator: Validators.compose([
              (v) => Validators.required(v, fieldName: 'Confirm password'),
              Validators.confirmPassword(() => _passwordController.text),
            ]),
            autovalidateMode: _autovalidateMode,
          ),
          const SizedBox(height: 32),
          AppPrimaryButton(
            onPressed: _canSubmit ? _signUp : null,
            label: 'CREATE ACCOUNT',
            isLoading: _isLoading,
            icon: Icons.person_add,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: widget.onLogin,
                child: Text(
                  'Login',
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
