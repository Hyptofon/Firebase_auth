import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lr16_firebase_auth/constants/app_constants.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';

class StorageService implements StorageRepository {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  // Use the shared constant - do not define a local copy.
  static const int _maxFileSizeBytes = AppConstants.maxImageFileSizeBytes;

  StorageService({FirebaseStorage? storage, FirebaseAuth? auth})
    : _storage = storage ?? FirebaseStorage.instance,
      _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String> uploadImage({
    required XFile file,
    required String noteId,
    void Function(double progress)? onProgress,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('User not authenticated');

    final fileSize = await file.length();
    if (fileSize > _maxFileSizeBytes) {
      throw ArgumentError(
        'File size exceeds ${_maxFileSizeBytes ~/ (1024 * 1024)}MB limit',
      );
    }

    final contentType = file.mimeType ?? 'image/jpeg';
    final extension = _extensionForContentType(contentType);
    final fileName =
        'image_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final ref = _storage
        .ref()
        .child('users')
        .child(user.uid)
        .child('notes')
        .child(noteId)
        .child(fileName);

    final metadata = SettableMetadata(
      contentType: contentType,
      customMetadata: {
        'userId': user.uid,
        'noteId': noteId,
        'sizeBytes': fileSize.toString(),
        'uploadedAt': DateTime.now().toIso8601String(),
      },
    );

    final uploadTask = ref.putData(await file.readAsBytes(), metadata);

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snapshot) {
        final totalBytes = snapshot.totalBytes;
        final progress = totalBytes == 0
            ? 0.0
            : snapshot.bytesTransferred / totalBytes;
        onProgress(progress);
      });
    }

    try {
      await uploadTask;
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      try {
        await ref.delete();
      } on FirebaseException {
        // The upload may have failed before a remote object was created.
      }
      throw StateError('Upload failed: ${e.message}');
    }
  }

  @override
  Future<void> deleteImage({required String imageUrl}) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException {
      return;
    }
  }

  String _extensionForContentType(String contentType) {
    return switch (contentType) {
      'image/png' => 'png',
      'image/gif' => 'gif',
      'image/webp' => 'webp',
      _ => 'jpg',
    };
  }
}
