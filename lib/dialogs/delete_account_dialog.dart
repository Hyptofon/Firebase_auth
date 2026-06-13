import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/constants/app_strings.dart';
import 'package:lr16_firebase_auth/widgets/app_text_field.dart';

Future<String?> showDeleteAccountDialog(BuildContext context) async {
  final confirmed = await _showDeleteConfirmationDialog(context);
  if (confirmed != true) return null;

  if (!context.mounted) return null;

  return _showPasswordConfirmationDialog(context);
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.error,
        size: 40,
      ),
      title: const Text(HomeStrings.deleteAccountTitle),
      content: const Text(HomeStrings.deleteAccountDialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(AppStrings.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text(HomeStrings.deleteForeverButton),
        ),
      ],
    ),
  );
}

Future<String?> _showPasswordConfirmationDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) => const _PasswordConfirmationDialog(),
  );
}

class _PasswordConfirmationDialog extends StatefulWidget {
  const _PasswordConfirmationDialog();

  @override
  State<_PasswordConfirmationDialog> createState() =>
      _PasswordConfirmationDialogState();
}

class _PasswordConfirmationDialogState
    extends State<_PasswordConfirmationDialog> {
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(HomeStrings.confirmPasswordTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(HomeStrings.confirmPasswordSubtitle),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _passwordController,
            labelText: AuthStrings.passwordLabel,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancelButton),
        ),
        FilledButton(
          onPressed: () {
            final password = _passwordController.text;
            Navigator.pop(context, password.isEmpty ? null : password);
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text(HomeStrings.confirmButton),
        ),
      ],
    );
  }
}
