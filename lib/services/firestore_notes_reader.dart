import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_reader_repository.dart';
import 'package:lr16_firebase_auth/services/firestore_notes_mixin.dart';

class FirestoreNotesReader
    with FirestoreNotesMixin
    implements NotesReaderRepository {
  @override
  final FirebaseFirestore firestore;

  @override
  final FirebaseAuth auth;

  FirestoreNotesReader({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<List<Note>> getNotes({int? limit}) {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    Query<Map<String, dynamic>> query = notesCollection(
      userId,
    ).orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Note.fromJson(doc.data(), doc.id))
          .toList(),
    );
  }

  @override
  Future<List<Note>> getNotesPage({int pageSize = 10, Note? lastNote}) async {
    final userId = currentUserId;
    if (userId == null) return [];

    Query<Map<String, dynamic>> query = notesCollection(
      userId,
    ).orderBy('createdAt', descending: true).limit(pageSize);

    if (lastNote != null) {
      query = query.startAfter([Timestamp.fromDate(lastNote.createdAt)]);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Note.fromJson(doc.data(), doc.id))
        .toList();
  }
}
