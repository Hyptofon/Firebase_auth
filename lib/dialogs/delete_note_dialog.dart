import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/constants/app_strings.dart';

class DeleteNoteDialog extends StatelessWidget {
  const DeleteNoteDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteNoteDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text(NotesStrings.deleteDialogTitle),
      content: const Text(NotesStrings.deleteDialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            NotesStrings.deleteButton,
            style: TextStyle(color: colorScheme.error),
          ),
        ),
      ],
    );
  }
}
