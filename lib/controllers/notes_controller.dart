import 'package:image_picker/image_picker.dart';

import 'package:lr16_firebase_auth/constants/app_constants.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/utils/image_picker_helper.dart';

class NotesController {
  final NotesRepository _notesRepository;
  final StorageRepository _storageRepository;

  const NotesController({
    required NotesRepository notesRepository,
    required StorageRepository storageRepository,
  }) : _notesRepository = notesRepository,
       _storageRepository = storageRepository;

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) {
    return pickImageFromSource(source);
  }

  Future<bool> validateImageSize(XFile file) async =>
      await file.length() <= AppConstants.maxImageFileSizeBytes;

  Future<void> saveNote({
    required String title,
    required String content,
    String? existingNoteId,
    String? currentImageUrl,
    XFile? newImage,
    bool removeImage = false,
    void Function(double)? onUploadProgress,
  }) async {
    if (existingNoteId != null) {
      await _updateExistingNote(
        noteId: existingNoteId,
        title: title,
        content: content,
        currentImageUrl: currentImageUrl,
        newImage: newImage,
        removeImage: removeImage,
        onUploadProgress: onUploadProgress,
      );
      return;
    }

    await _createNewNote(
      title: title,
      content: content,
      newImage: newImage,
      onUploadProgress: onUploadProgress,
    );
  }

  Future<void> _createNewNote({
    required String title,
    required String content,
    XFile? newImage,
    void Function(double)? onUploadProgress,
  }) async {
    final noteId = await _notesRepository.createNote(
      title: title,
      content: content,
      imageUrl: null,
    );

    if (newImage == null) return;

    String imageUrl;
    try {
      imageUrl = await _storageRepository.uploadImage(
        file: newImage,
        noteId: noteId,
        onProgress: onUploadProgress,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }

    try {
      await _notesRepository.updateNote(
        noteId: noteId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );
    } catch (error, stackTrace) {
      await _deleteImageIfExists(imageUrl: imageUrl);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> _updateExistingNote({
    required String noteId,
    required String title,
    required String content,
    required String? currentImageUrl,
    XFile? newImage,
    bool removeImage = false,
    void Function(double)? onUploadProgress,
  }) async {
    String? imageUrl = removeImage ? null : currentImageUrl;
    String? uploadedImageUrl;
    final oldImageUrl = newImage != null || removeImage
        ? currentImageUrl
        : null;

    try {
      if (newImage != null) {
        uploadedImageUrl = await _storageRepository.uploadImage(
          file: newImage,
          noteId: noteId,
          onProgress: onUploadProgress,
        );
        imageUrl = uploadedImageUrl;
      }

      await _notesRepository.updateNote(
        noteId: noteId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );

      await _deleteImageIfExists(imageUrl: oldImageUrl);
    } catch (error, stackTrace) {
      try {
        await _deleteImageIfExists(imageUrl: uploadedImageUrl);
      } catch (_) {}
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteNoteWithImage({
    required String noteId,
    String? imageUrl,
  }) async {
    await _deleteImageIfExists(imageUrl: imageUrl);
    await _notesRepository.deleteNote(noteId: noteId);
  }

  Future<void> _deleteImageIfExists({required String? imageUrl}) async {
    if (imageUrl == null) return;
    await _storageRepository.deleteImage(imageUrl: imageUrl);
  }
}
