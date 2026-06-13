import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';

class ImageActionButtons extends StatelessWidget {
  final bool hasImage;
  final bool isUploading;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const ImageActionButtons({
    super.key,
    required this.hasImage,
    required this.isUploading,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isUploading ? null : onPickImage,
            icon: const Icon(Icons.photo_camera_outlined, size: 18),
            label: Text(
              hasImage
                  ? NotesStrings.changePhotoButton
                  : NotesStrings.addPhotoButton,
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (hasImage) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isUploading ? null : onRemoveImage,
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: colorScheme.error,
              ),
              label: Text(
                NotesStrings.removeButton,
                style: TextStyle(color: colorScheme.error),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: colorScheme.error.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
