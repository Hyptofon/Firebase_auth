import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/constants/app_strings.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.logout,
        color: Theme.of(context).colorScheme.error,
        size: 32,
      ),
      title: const Text(HomeStrings.logoutDialogTitle),
      content: const Text(HomeStrings.logoutDialogContent),
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
          child: const Text(HomeStrings.logoutButton),
        ),
      ],
    ),
  );
  return result ?? false;
}
