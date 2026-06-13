class NotesStrings {
  NotesStrings._();

  static const screenTitle = 'My Notes';
  static const newNoteTitle = 'New Note';
  static const editNoteTitle = 'Edit Note';

  static const titleLabel = 'Title';
  static const titleFieldName = 'Title';
  static const contentLabel = 'Content';
  static const attachmentLabel = 'Attachment';
  static const searchHint = 'Search notes';
  static const pageSizeLabel = 'Show';
  static const pageSizeFive = '5';
  static const pageSizeTen = '10';
  static const pageSizeAll = 'All';

  static const emptyTitle = 'No notes yet';
  static const emptySubtitle = 'Tap the button below to create your first note';
  static const createNoteButton = 'Create Note';
  static const noSearchResults = 'No notes match your search';
  static const loadMoreButton = 'Load more';

  static const addPhotoButton = 'Add Photo';
  static const changePhotoButton = 'Change Photo';
  static const takePhotoButton = 'Take Photo';
  static const chooseFromGalleryButton = 'Choose from Gallery';
  static const removeButton = 'Remove';
  static const uploadingFormat = 'Uploading...';

  static const deleteDialogTitle = 'Delete Note';
  static const deleteDialogContent =
      'This action cannot be undone. The note and its attached image will be permanently deleted.';
  static const deleteButton = 'Delete';

  static const noteCreated = 'Note created';
  static const noteUpdated = 'Note updated';
  static const noteDeleted = 'Note deleted';
  static const imageTooLarge = 'Image is too large. Maximum size is 5MB.';
  static const failedToSaveNote = 'Failed to save note';
  static const failedToDeleteNote = 'Failed to delete note';
  static const failedToLoadNotes = 'Failed to load notes';

  static const errorTitle = 'Something went wrong';

  static const myNotesNavTitle = 'My Notes';
  static const myNotesNavSubtitle = 'Create, edit and manage your notes';

  static String uploadProgress(int percent) => '$uploadingFormat $percent%';

  static String saveError(String? details) =>
      details != null ? '$failedToSaveNote: $details' : failedToSaveNote;

  static String deleteError(String? details) =>
      details != null ? '$failedToDeleteNote: $details' : failedToDeleteNote;

  static String loadError(String? details) =>
      details != null ? '$failedToLoadNotes: $details' : failedToLoadNotes;
}
