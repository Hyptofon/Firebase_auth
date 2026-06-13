import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/screens/notes_screen.dart';
import 'package:lr16_firebase_auth/widgets/action_tile.dart';

class NotesNavigationSection extends StatelessWidget {
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;

  const NotesNavigationSection({
    super.key,
    required this.notesRepository,
    required this.storageRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ActionTile(
      icon: Icons.note_alt_outlined,
      title: NotesStrings.myNotesNavTitle,
      subtitle: NotesStrings.myNotesNavSubtitle,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NotesScreen(
            notesRepository: notesRepository,
            storageRepository: storageRepository,
          ),
        ),
      ),
    );
  }
}
