import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromSource(ImageSource source) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: source,
    maxWidth: 1920,
    maxHeight: 1080,
    imageQuality: 85,
  );
  return image;
}

Future<XFile?> pickImageFromGallery() {
  return pickImageFromSource(ImageSource.gallery);
}
