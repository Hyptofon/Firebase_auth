abstract class NotesWriterRepository {
  Future<String> createNote({
    required String title,
    required String content,
    String? imageUrl,
  });

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
    String? imageUrl,
  });

  Future<void> deleteNote({required String noteId});
}
