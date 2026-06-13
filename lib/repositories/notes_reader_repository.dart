import 'package:lr16_firebase_auth/models/note.dart';

abstract class NotesReaderRepository {
  Stream<List<Note>> getNotes({int? limit});

  Future<List<Note>> getNotesPage({int pageSize = 10, Note? lastNote});
}
