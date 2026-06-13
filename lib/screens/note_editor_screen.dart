import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lr16_firebase_auth/controllers/note_editor_controller.dart';
import 'package:lr16_firebase_auth/controllers/notes_controller.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/utils/snack_bar_helper.dart';
import 'package:lr16_firebase_auth/widgets/notes/note_editor_form.dart';
import 'package:lr16_firebase_auth/widgets/notes/save_note_button.dart';

class NoteEditorScreen extends StatefulWidget {
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;
  final Note? note;

  const NoteEditorScreen({
    super.key,
    required this.notesRepository,
    required this.storageRepository,
    this.note,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final NotesController _notesController;

  /// All mutable editor state is owned by [NoteEditorController], keeping this
  /// widget focused on layout and user interaction only.
  late final NoteEditorController _editorController;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _notesController = NotesController(
      notesRepository: widget.notesRepository,
      storageRepository: widget.storageRepository,
    );
    _editorController = NoteEditorController(
      initialImageUrl: widget.note?.imageUrl,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _editorController,
      builder: (context, _) {
        return PopScope(
          canPop: !_editorController.isSaving,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                _isEditing
                    ? NotesStrings.editNoteTitle
                    : NotesStrings.newNoteTitle,
              ),
              actions: [
                SaveNoteButton(
                  isSaving: _editorController.isSaving,
                  onPressed: _saveNote,
                ),
              ],
            ),
            body: NoteEditorForm(
              formKey: _formKey,
              titleController: _titleController,
              contentController: _contentController,
              currentImageUrl: _editorController.displayImageUrl,
              selectedImage: _editorController.selectedImage,
              isUploading: _editorController.isUploading,
              uploadProgress: _editorController.uploadProgress,
              onPickImage: _pickImage,
              onRemoveImage: _editorController.removeImage,
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final source = await _selectImageSource();
    if (!mounted || source == null) return;

    final file = await _notesController.pickImage(source: source);
    if (file == null) return;

    final isValid = await _notesController.validateImageSize(file);

    if (!mounted) return;

    if (!isValid) {
      context.showErrorSnackBar(NotesStrings.imageTooLarge);
      return;
    }

    _editorController.selectImage(file);
  }

  Future<ImageSource?> _selectImageSource() async {
    if (!_usesMobileImageSources) return ImageSource.gallery;

    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text(NotesStrings.takePhotoButton),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text(NotesStrings.chooseFromGalleryButton),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  bool get _usesMobileImageSources {
    final platform = defaultTargetPlatform;
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    _editorController.setSaving(true);
    if (_editorController.selectedImage != null) {
      _editorController.setUploading(true);
    }

    try {
      await _notesController.saveNote(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        existingNoteId: widget.note?.id,
        currentImageUrl: _editorController.currentImageUrl,
        newImage: _editorController.selectedImage,
        removeImage: _editorController.shouldRemoveImage,
        onUploadProgress: _handleUploadProgress,
      );

      if (mounted) {
        _editorController.reset();
        context.showSuccessSnackBar(
          _isEditing ? NotesStrings.noteUpdated : NotesStrings.noteCreated,
        );
        Navigator.of(context).pop();
      }
    } on FirebaseException catch (e) {
      _handleSaveError(NotesStrings.saveError(e.message));
    } on StateError catch (e) {
      _handleSaveError(e.message);
    } on ArgumentError catch (e) {
      _handleSaveError(e.message);
    } catch (e) {
      _handleSaveError(NotesStrings.saveError(e.toString()));
    }
  }

  void _handleSaveError(String message) {
    if (mounted) {
      _editorController.reset();
      context.showErrorSnackBar(message);
    }
  }

  void _handleUploadProgress(double progress) {
    if (!mounted) return;
    _editorController.setUploadProgress(progress);
  }
}
