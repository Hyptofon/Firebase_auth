import 'package:flutter/material.dart';

class SaveNoteButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback? onPressed;

  const SaveNoteButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isSaving ? null : onPressed,
      icon: isSaving
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          : const Icon(Icons.check),
    );
  }
}
