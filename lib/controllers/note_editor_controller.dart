import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class NoteEditorController extends ChangeNotifier {
  XFile? _selectedImage;
  final String? _currentImageUrl;
  bool _isSaving = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _removeExistingImage = false;

  NoteEditorController({String? initialImageUrl})
    : _currentImageUrl = initialImageUrl;

  XFile? get selectedImage => _selectedImage;

  String? get displayImageUrl => _removeExistingImage ? null : _currentImageUrl;

  bool get isSaving => _isSaving;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;

  void selectImage(XFile file) {
    _selectedImage = file;
    _removeExistingImage = false;
    notifyListeners();
  }

  void removeImage() {
    _selectedImage = null;
    if (_currentImageUrl != null) {
      _removeExistingImage = true;
    }
    notifyListeners();
  }

  void setSaving(bool value) {
    if (_isSaving == value) return;
    _isSaving = value;
    notifyListeners();
  }

  void setUploading(bool value) {
    if (_isUploading == value) return;
    _isUploading = value;
    notifyListeners();
  }

  void setUploadProgress(double value) {
    _uploadProgress = value;
    notifyListeners();
  }

  void reset() {
    _isSaving = false;
    _isUploading = false;
    _uploadProgress = 0.0;
    notifyListeners();
  }

  bool get shouldRemoveImage => _removeExistingImage;
  String? get currentImageUrl => _currentImageUrl;
}
