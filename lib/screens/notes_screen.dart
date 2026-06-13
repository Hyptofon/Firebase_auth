import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/widgets/notes/notes_body.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatelessWidget {
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;

  const NotesScreen({
    super.key,
    required this.notesRepository,
    required this.storageRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(NotesStrings.screenTitle)),
      body: NotesBody(
        notesRepository: notesRepository,
        storageRepository: storageRepository,
        onNavigateToEditor: (note) => _navigateToEditor(context, note: note),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditor(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditor(BuildContext context, {Note? note}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          notesRepository: notesRepository,
          storageRepository: storageRepository,
          note: note,
        ),
      ),
    );
  }
}
