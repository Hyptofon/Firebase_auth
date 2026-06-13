import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lr16_firebase_auth/repositories/notes_writer_repository.dart';
import 'package:lr16_firebase_auth/services/firestore_notes_mixin.dart';

class FirestoreNotesWriter
    with FirestoreNotesMixin
    implements NotesWriterRepository {
  @override
  final FirebaseFirestore firestore;

  @override
  final FirebaseAuth auth;

  FirestoreNotesWriter({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String> createNote({
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final docRef = await notesCollection(userId).add({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await notesCollection(userId).doc(noteId).update({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteNote({required String noteId}) async {
    final userId = currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await notesCollection(userId).doc(noteId).delete();
  }
}
