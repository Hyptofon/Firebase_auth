import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/utils/validators.dart';

class ContentField extends StatelessWidget {
  final TextEditingController controller;

  const ContentField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      maxLines: 8,
      textInputAction: TextInputAction.newline,
      validator: Validators.maxLength(
        10000,
        fieldName: NotesStrings.contentLabel,
      ),
      decoration: InputDecoration(
        labelText: NotesStrings.contentLabel,
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: Icon(Icons.notes, color: colorScheme.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
      ),
    );
  }
}
