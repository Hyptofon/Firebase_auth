import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'note_card.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;
  final ValueChanged<Note> onOpenNote;
  final Future<void> Function(Note note) onDeleteNote;

  const NotesList({
    super.key,
    required this.notes,
    required this.onOpenNote,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: NoteCard(
            note: note,
            onTap: () => onOpenNote(note),
            onDelete: () => onDeleteNote(note),
          ),
        );
      },
    );
  }
}
