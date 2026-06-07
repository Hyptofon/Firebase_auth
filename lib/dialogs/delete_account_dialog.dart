import 'package:flutter/material.dart';
import '../widgets/app_text_field.dart';

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
      title: const Text('Delete Account'),
      content: const Text(
        'This action is permanent and cannot be undone. '
        'All your data will be lost. Are you sure?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete Forever'),
        ),
      ],
    ),
  );
}

Future<String?> _showPasswordConfirmationDialog(BuildContext context) async {
  final passwordController = TextEditingController();

  final password = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Your Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your password to confirm account deletion.'),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: passwordController,
            labelText: 'Password',
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, passwordController.text),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );

  passwordController.dispose();
  return (password == null || password.isEmpty) ? null : password;
}
