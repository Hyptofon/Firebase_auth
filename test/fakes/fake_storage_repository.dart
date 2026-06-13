import 'package:image_picker/image_picker.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';

class FakeStorageRepository implements StorageRepository {
  @override
  Future<String> uploadImage({
    required XFile file,
    required String noteId,
    void Function(double progress)? onProgress,
  }) async => 'https://storage.example/$noteId.jpg';

  @override
  Future<void> deleteImage({required String imageUrl}) async {}
}
