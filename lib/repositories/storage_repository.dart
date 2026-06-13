import 'package:image_picker/image_picker.dart';

abstract class StorageRepository {
  Future<String> uploadImage({
    required XFile file,
    required String noteId,
    void Function(double progress)? onProgress,
  });

  Future<void> deleteImage({required String imageUrl});
}
