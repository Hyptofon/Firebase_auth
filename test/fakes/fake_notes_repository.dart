import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';

class FakeNotesRepository implements NotesRepository {
  @override
  Stream<List<Note>> getNotes({int? limit}) => Stream.value([]);

  @override
  Future<List<Note>> getNotesPage({int pageSize = 10, Note? lastNote}) async =>
      [];

  @override
  Future<String> createNote({
    required String title,
    required String content,
    String? imageUrl,
  }) async => 'fake-note-id';

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {}

  @override
  Future<void> deleteNote({required String noteId}) async {}
}
