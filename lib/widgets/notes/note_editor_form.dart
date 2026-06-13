import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/utils/validators.dart';
import 'package:lr16_firebase_auth/widgets/app_text_field.dart';
import 'content_field.dart';
import 'note_image_section.dart';

class NoteEditorForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String? currentImageUrl;
  final XFile? selectedImage;
  final bool isUploading;
  final double uploadProgress;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const NoteEditorForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.contentController,
    this.currentImageUrl,
    this.selectedImage,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: titleController,
              labelText: NotesStrings.titleLabel,
              prefixIcon: Icons.title,
              textInputAction: TextInputAction.next,
              validator: Validators.compose([
                (v) => Validators.required(
                  v,
                  fieldName: NotesStrings.titleFieldName,
                ),
                Validators.maxLength(
                  120,
                  fieldName: NotesStrings.titleFieldName,
                ),
              ]),
            ),
            const SizedBox(height: 16),
            ContentField(controller: contentController),
            const SizedBox(height: 24),
            NoteImageSection(
              currentImageUrl: currentImageUrl,
              selectedImage: selectedImage,
              isUploading: isUploading,
              uploadProgress: uploadProgress,
              onPickImage: onPickImage,
              onRemoveImage: onRemoveImage,
            ),
          ],
        ),
      ),
    );
  }
}
