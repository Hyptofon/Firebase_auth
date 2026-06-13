import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lr16_firebase_auth/controllers/notes_controller.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';

void main() {
  group('NotesController', () {
    test('creates note without uploading when no image is selected', () async {
      final notesRepository = FakeNotesRepository();
      final storageRepository = FakeStorageRepository();
      final controller = NotesController(
        notesRepository: notesRepository,
        storageRepository: storageRepository,
      );

      await controller.saveNote(title: 'Title', content: 'Content');

      expect(notesRepository.createdNotes, hasLength(1));
      expect(notesRepository.createdNotes.single.title, 'Title');
      expect(storageRepository.uploadedNoteIds, isEmpty);
      expect(notesRepository.updatedNotes, isEmpty);
    });

    test('uploads new note image using the real Firestore note id', () async {
      final notesRepository = FakeNotesRepository(nextCreatedId: 'note-42');
      final storageRepository = FakeStorageRepository();
      final controller = NotesController(
        notesRepository: notesRepository,
        storageRepository: storageRepository,
      );

      await controller.saveNote(
        title: 'Photo note',
        content: 'Content',
        newImage: _testImage(),
      );

      expect(notesRepository.createdNotes, hasLength(1));
      expect(storageRepository.uploadedNoteIds.single, 'note-42');
      // Image URL is written back via updateNote (not a separate updateNoteImage call).
      expect(notesRepository.updatedNotes.single.noteId, 'note-42');
      expect(
        notesRepository.updatedNotes.single.imageUrl,
        'https://storage.example/note-42.jpg',
      );
    });

    test(
      'note is created without image when upload fails (no orphan Storage file)',
      () async {
        final notesRepository = FakeNotesRepository(
          nextCreatedId: 'note-rollback',
        );
        final storageRepository = FakeStorageRepository(failUpload: true);
        final controller = NotesController(
          notesRepository: notesRepository,
          storageRepository: storageRepository,
        );

        await expectLater(
          controller.saveNote(
            title: 'Photo note',
            content: 'Content',
            newImage: _testImage(),
          ),
          throwsA(isA<StateError>()),
        );

        // The Firestore note is created first, so it exists without an imageUrl.
        // No Storage file was successfully written, so nothing to clean up.
        expect(notesRepository.createdNotes, hasLength(1));
        expect(notesRepository.deletedNoteIds, isEmpty);
        expect(storageRepository.deletedImageUrls, isEmpty);
      },
    );

    test('rolls back uploaded image when Firestore URL update fails', () async {
      final notesRepository = FakeNotesRepository(
        nextCreatedId: 'note-update-fail',
        failUpdateImageUrl: true,
      );
      final storageRepository = FakeStorageRepository();
      final controller = NotesController(
        notesRepository: notesRepository,
        storageRepository: storageRepository,
      );

      await expectLater(
        controller.saveNote(
          title: 'Photo note',
          content: 'Content',
          newImage: _testImage(),
        ),
        throwsA(isA<StateError>()),
      );

      // The uploaded image is cleaned up; the note document still exists
      // without an imageUrl (acceptable state).
      expect(
        storageRepository.deletedImageUrls.single,
        'https://storage.example/note-update-fail.jpg',
      );
    });

    test(
      'deletes the old image after replacing an existing note image',
      () async {
        final notesRepository = FakeNotesRepository();
        final storageRepository = FakeStorageRepository();
        final controller = NotesController(
          notesRepository: notesRepository,
          storageRepository: storageRepository,
        );

        await controller.saveNote(
          title: 'Updated',
          content: 'Content',
          existingNoteId: 'existing-note',
          currentImageUrl: 'https://storage.example/old.jpg',
          newImage: _testImage(),
        );

        expect(storageRepository.uploadedNoteIds.single, 'existing-note');
        expect(notesRepository.updatedNotes.single.noteId, 'existing-note');
        expect(
          notesRepository.updatedNotes.single.imageUrl,
          'https://storage.example/existing-note.jpg',
        );
        expect(
          storageRepository.deletedImageUrls.single,
          'https://storage.example/old.jpg',
        );
      },
    );

    test(
      'cleans up the newly uploaded image if existing note update fails',
      () async {
        final notesRepository = FakeNotesRepository(failUpdate: true);
        final storageRepository = FakeStorageRepository();
        final controller = NotesController(
          notesRepository: notesRepository,
          storageRepository: storageRepository,
        );

        await expectLater(
          controller.saveNote(
            title: 'Updated',
            content: 'Content',
            existingNoteId: 'existing-note',
            currentImageUrl: 'https://storage.example/old.jpg',
            newImage: _testImage(),
          ),
          throwsA(isA<StateError>()),
        );

        expect(
          storageRepository.deletedImageUrls.single,
          'https://storage.example/existing-note.jpg',
        );
      },
    );

    test('deletes the image before deleting the note document', () async {
      final notesRepository = FakeNotesRepository();
      final storageRepository = FakeStorageRepository();
      final controller = NotesController(
        notesRepository: notesRepository,
        storageRepository: storageRepository,
      );

      await controller.deleteNoteWithImage(
        noteId: 'note-delete',
        imageUrl: 'https://storage.example/delete.jpg',
      );

      expect(
        storageRepository.deletedImageUrls.single,
        'https://storage.example/delete.jpg',
      );
      expect(notesRepository.deletedNoteIds.single, 'note-delete');
    });
  });
}

XFile _testImage() {
  return XFile.fromData(
    Uint8List.fromList([1, 2, 3]),
    mimeType: 'image/jpeg',
    name: 'test.jpg',
  );
}

class FakeNotesRepository implements NotesRepository {
  final String nextCreatedId;

  /// When true, `updateNote` throws - simulates Firestore URL write failure.
  final bool failUpdateImageUrl;
  final bool failUpdate;

  final List<CreatedNote> createdNotes = [];
  final List<UpdatedNote> updatedNotes = [];
  final List<String> deletedNoteIds = [];

  FakeNotesRepository({
    this.nextCreatedId = 'note-1',
    this.failUpdateImageUrl = false,
    this.failUpdate = false,
  });

  @override
  Stream<List<Note>> getNotes({int? limit}) => Stream.value([]);

  @override
  Future<List<Note>> getNotesPage({int pageSize = 10, Note? lastNote}) async {
    return [];
  }

  @override
  Future<String> createNote({
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    createdNotes.add(
      CreatedNote(title: title, content: content, imageUrl: imageUrl),
    );
    return nextCreatedId;
  }

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    if (failUpdate) throw StateError('Update failed');
    // Simulate image URL write failure only when the update carries a new URL.
    if (failUpdateImageUrl && imageUrl != null) {
      throw StateError('Image URL update failed');
    }
    updatedNotes.add(
      UpdatedNote(
        noteId: noteId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  Future<void> deleteNote({required String noteId}) async {
    deletedNoteIds.add(noteId);
  }
}

class FakeStorageRepository implements StorageRepository {
  final bool failUpload;

  final List<String> uploadedNoteIds = [];
  final List<String> deletedImageUrls = [];

  FakeStorageRepository({this.failUpload = false});

  @override
  Future<String> uploadImage({
    required XFile file,
    required String noteId,
    void Function(double progress)? onProgress,
  }) async {
    uploadedNoteIds.add(noteId);
    onProgress?.call(1);
    if (failUpload) throw StateError('Upload failed');
    return 'https://storage.example/$noteId.jpg';
  }

  @override
  Future<void> deleteImage({required String imageUrl}) async {
    deletedImageUrls.add(imageUrl);
  }
}

class CreatedNote {
  final String title;
  final String content;
  final String? imageUrl;

  const CreatedNote({
    required this.title,
    required this.content,
    required this.imageUrl,
  });
}

class UpdatedNote {
  final String noteId;
  final String title;
  final String content;
  final String? imageUrl;

  const UpdatedNote({
    required this.noteId,
    required this.title,
    required this.content,
    required this.imageUrl,
  });
}
