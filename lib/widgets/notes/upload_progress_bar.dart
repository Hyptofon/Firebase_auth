import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';

class UploadProgressBar extends StatelessWidget {
  final double progress;

  const UploadProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show indeterminate bar until the first Storage snapshot arrives (progress == 0).
    final double? barValue = progress > 0.0 ? progress : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: barValue,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 6),
          Text(
            progress > 0.0
                ? NotesStrings.uploadProgress((progress * 100).toInt())
                : NotesStrings.uploadProgress(0),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
