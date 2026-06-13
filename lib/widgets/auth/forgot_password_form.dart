import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/utils/snack_bar_helper.dart';
import 'package:lr16_firebase_auth/utils/validators.dart';
import 'package:lr16_firebase_auth/widgets/app_button.dart';
import 'package:lr16_firebase_auth/widgets/app_text_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  final AuthCredentialsRepository authRepository;
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({
    super.key,
    required this.authRepository,
    required this.onBackToLogin,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;
  bool _hasSubmitted = false;
  bool _canSubmit = false;

  AutovalidateMode get _autovalidateMode => _hasSubmitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateCanSubmit);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateCanSubmit);
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_canSubmit || _isLoading) return;

    setState(() => _hasSubmitted = true);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await widget.authRepository.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case AuthSuccess():
        break;
      case AuthMessageSuccess(:final message):
        setState(() => _emailSent = true);
        context.showSuccessSnackBar(message);
        break;
      case AuthFailure(:final message):
        context.showErrorSnackBar(message);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _emailSent
                ? colorScheme.tertiaryContainer
                : colorScheme.errorContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _emailSent ? Icons.mark_email_read_outlined : Icons.lock_reset,
            size: 40,
            color: _emailSent ? colorScheme.tertiary : colorScheme.error,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _emailSent
              ? AuthStrings.resetEmailSentTitle
              : AuthStrings.resetPasswordTitle,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          _emailSent
              ? AuthStrings.resetEmailSentSubtitle
              : AuthStrings.resetPasswordSubtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        if (_emailSent)
          _SuccessActions(onRetry: _retry, onBack: widget.onBackToLogin)
        else
          _ResetPasswordFields(
            formKey: _formKey,
            emailController: _emailController,
            isLoading: _isLoading,
            canSubmit: _canSubmit,
            autovalidateMode: _autovalidateMode,
            onSubmit: _resetPassword,
          ),
      ],
    );
  }

  void _retry() {
    setState(() => _emailSent = false);
  }

  void _updateCanSubmit() {
    final canSubmit = _emailController.text.trim().isNotEmpty;

    if (canSubmit == _canSubmit) return;
    setState(() => _canSubmit = canSubmit);
  }
}

class _SuccessActions extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _SuccessActions({required this.onRetry, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 64,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          onPressed: onBack,
          label: AuthStrings.backToLogin,
          icon: Icons.arrow_back,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onRetry,
          child: const Text(AuthStrings.resetEmailRetry),
        ),
      ],
    );
  }
}

class _ResetPasswordFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final bool canSubmit;
  final AutovalidateMode autovalidateMode;
  final VoidCallback onSubmit;

  const _ResetPasswordFields({
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.canSubmit,
    required this.autovalidateMode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: emailController,
            labelText: AuthStrings.emailLabel,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            validator: Validators.compose([
              (v) =>
                  Validators.required(v, fieldName: AuthStrings.emailFieldName),
              Validators.email,
            ]),
            autovalidateMode: autovalidateMode,
          ),
          const SizedBox(height: 24),
          AppPrimaryButton(
            onPressed: canSubmit ? onSubmit : null,
            label: AuthStrings.resetPasswordButton,
            isLoading: isLoading,
            icon: Icons.send,
          ),
        ],
      ),
    );
  }
}
