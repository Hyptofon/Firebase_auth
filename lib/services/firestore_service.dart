import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_reader_repository.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/notes_writer_repository.dart';
import 'package:lr16_firebase_auth/services/firestore_notes_reader.dart';
import 'package:lr16_firebase_auth/services/firestore_notes_writer.dart';

class FirestoreService implements NotesRepository {
  final NotesReaderRepository _reader;
  final NotesWriterRepository _writer;

  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    NotesReaderRepository? reader,
    NotesWriterRepository? writer,
  }) : _reader =
           reader ?? FirestoreNotesReader(firestore: firestore, auth: auth),
       _writer =
           writer ?? FirestoreNotesWriter(firestore: firestore, auth: auth);

  @override
  Stream<List<Note>> getNotes({int? limit}) => _reader.getNotes(limit: limit);

  @override
  Future<List<Note>> getNotesPage({int pageSize = 10, Note? lastNote}) {
    return _reader.getNotesPage(pageSize: pageSize, lastNote: lastNote);
  }

  @override
  Future<String> createNote({
    required String title,
    required String content,
    String? imageUrl,
  }) {
    return _writer.createNote(
      title: title,
      content: content,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
    String? imageUrl,
  }) {
    return _writer.updateNote(
      noteId: noteId,
      title: title,
      content: content,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> deleteNote({required String noteId}) {
    return _writer.deleteNote(noteId: noteId);
  }
}
