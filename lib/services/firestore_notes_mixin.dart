import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin FirestoreNotesMixin {
  FirebaseFirestore get firestore;

  FirebaseAuth get auth;

  String? get currentUserId => auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> notesCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('notes');
  }
}
