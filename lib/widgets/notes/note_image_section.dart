import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'image_action_buttons.dart';
import 'image_preview.dart';
import 'upload_progress_bar.dart';

class NoteImageSection extends StatelessWidget {
  final String? currentImageUrl;
  final XFile? selectedImage;
  final bool isUploading;
  final double uploadProgress;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const NoteImageSection({
    super.key,
    this.currentImageUrl,
    this.selectedImage,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          NotesStrings.attachmentLabel,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        if (isUploading) UploadProgressBar(progress: uploadProgress),
        if (selectedImage != null)
          LocalImagePreview(file: selectedImage!)
        else if (currentImageUrl != null)
          NetworkImagePreview(imageUrl: currentImageUrl!),
        const SizedBox(height: 12),
        ImageActionButtons(
          hasImage: selectedImage != null || currentImageUrl != null,
          isUploading: isUploading,
          onPickImage: onPickImage,
          onRemoveImage: onRemoveImage,
        ),
      ],
    );
  }
}
