import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/dialogs/delete_note_dialog.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/utils/date_formatter.dart';
import 'image_preview.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final Future<void> Function() onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        final confirmed = await DeleteNoteDialog.show(context);
        if (!confirmed) return false;

        await onDelete();
        return false;
      },
      background: _DismissBackground(colorScheme: colorScheme),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.imageUrl != null) ...[
                  NetworkImagePreview(imageUrl: note.imageUrl!, height: 140),
                  const SizedBox(height: 12),
                ],
                _NoteTitle(title: note.title),
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _NoteContentPreview(content: note.content),
                ],
                const SizedBox(height: 16),
                _NoteTimestamp(createdAt: note.createdAt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  final ColorScheme colorScheme;

  const _DismissBackground({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.delete_outline, color: colorScheme.error),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String title;

  const _NoteTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _NoteContentPreview extends StatelessWidget {
  final String content;

  const _NoteContentPreview({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _NoteTimestamp extends StatelessWidget {
  final DateTime createdAt;

  const _NoteTimestamp({required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          formatDateTime(createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
