import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/controllers/notes_controller.dart';
import 'package:lr16_firebase_auth/models/note.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/utils/snack_bar_helper.dart';
import 'package:lr16_firebase_auth/widgets/error_view.dart';
import 'empty_notes_view.dart';
import 'load_more_button.dart';
import 'no_search_results.dart';
import 'notes_list.dart';
import 'notes_search_field.dart';

class NotesBody extends StatefulWidget {
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;
  final void Function(Note? note) onNavigateToEditor;

  const NotesBody({
    super.key,
    required this.notesRepository,
    required this.storageRepository,
    required this.onNavigateToEditor,
  });

  @override
  State<NotesBody> createState() => _NotesBodyState();
}

class _NotesBodyState extends State<NotesBody> {
  static const int _showAllPageSize = 0;
  static const List<int> _pageSizeOptions = [5, 10, _showAllPageSize];

  final _searchController = TextEditingController();

  final List<Note> _extraNotes = [];

  late Stream<List<Note>> _notesStream;
  int _selectedPageSize = 10;
  String _searchQuery = '';
  bool _hasMorePages = true;
  bool _isLoadingMore = false;
  late final NotesController _controller;

  bool get _isShowingAll => _selectedPageSize == _showAllPageSize;

  bool get _isSearching => _searchQuery.isNotEmpty;

  int? get _streamLimit => _isShowingAll ? null : _selectedPageSize;

  @override
  void initState() {
    super.initState();
    _notesStream = widget.notesRepository.getNotes(limit: _streamLimit);
    _controller = NotesController(
      notesRepository: widget.notesRepository,
      storageRepository: widget.storageRepository,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: _notesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorView(error: snapshot.error.toString());
        }

        final firstPageNotes = snapshot.data ?? [];
        final rawNotes = _mergeNotes(firstPageNotes, _extraNotes);

        final canLoadMore =
            !_isSearching &&
            !_isShowingAll &&
            firstPageNotes.length == _selectedPageSize &&
            _hasMorePages;
        final filteredNotes = _filterNotes(rawNotes);

        return Column(
          children: [
            NotesSearchField(
              controller: _searchController,
              onChanged: _updateSearchQuery,
              onClear: _clearSearch,
            ),
            _PageSizeSelector(
              selectedPageSize: _selectedPageSize,
              pageSizeOptions: _pageSizeOptions,
              onChanged: _changePageSize,
            ),
            Expanded(
              child: rawNotes.isEmpty && !_isSearching
                  ? EmptyNotesView(
                      onCreateNote: () => widget.onNavigateToEditor(null),
                    )
                  : filteredNotes.isEmpty
                  ? const NoSearchResults()
                  : NotesList(
                      notes: filteredNotes,
                      onOpenNote: (note) => widget.onNavigateToEditor(note),
                      onDeleteNote: (note) => _deleteNote(context, note),
                    ),
            ),
            if (canLoadMore)
              LoadMoreButton(
                isLoading: _isLoadingMore,
                onPressed: () => _loadMoreNotes(firstPageNotes),
              ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(BuildContext context, Note note) async {
    try {
      await _controller.deleteNoteWithImage(
        noteId: note.id,
        imageUrl: note.imageUrl,
      );
      if (context.mounted) {
        context.showSuccessSnackBar(NotesStrings.noteDeleted);
      }
      if (mounted) {
        setState(() => _extraNotes.removeWhere((item) => item.id == note.id));
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar(NotesStrings.deleteError(e.message));
      }
    } on StateError catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar(e.message);
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar(NotesStrings.deleteError(e.toString()));
      }
    }
  }

  List<Note> _mergeNotes(List<Note> firstPageNotes, List<Note> extraNotes) {
    final seenIds = firstPageNotes.map((note) => note.id).toSet();
    return [
      ...firstPageNotes,
      ...extraNotes.where((note) => seenIds.add(note.id)),
    ];
  }

  List<Note> _filterNotes(List<Note> notes) {
    if (!_isSearching) return notes;

    return notes.where((note) {
      final title = note.title.toLowerCase();
      final content = note.content.toLowerCase();
      return title.contains(_searchQuery) || content.contains(_searchQuery);
    }).toList();
  }

  void _updateSearchQuery(String value) {
    setState(() => _searchQuery = value.trim().toLowerCase());
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  Future<void> _loadMoreNotes(List<Note> firstPageNotes) async {
    if (_isLoadingMore || _isSearching || !_hasMorePages) return;

    final loadedNotes = _mergeNotes(firstPageNotes, _extraNotes);
    if (loadedNotes.isEmpty) return;

    setState(() => _isLoadingMore = true);

    try {
      final nextPage = await widget.notesRepository.getNotesPage(
        pageSize: _selectedPageSize,
        lastNote: loadedNotes.last,
      );

      if (!mounted) return;

      setState(() {
        _hasMorePages = nextPage.length == _selectedPageSize;

        final loadedIds = _mergeNotes(
          firstPageNotes,
          _extraNotes,
        ).map((note) => note.id).toSet();
        _extraNotes.addAll(nextPage.where((note) => loadedIds.add(note.id)));
        _isLoadingMore = false;
      });
    } on FirebaseException catch (e) {
      _handleLoadMoreError(NotesStrings.loadError(e.message));
    } on StateError catch (e) {
      _handleLoadMoreError(e.message);
    } catch (e) {
      _handleLoadMoreError(NotesStrings.loadError(e.toString()));
    }
  }

  void _handleLoadMoreError(String message) {
    if (!mounted) return;

    setState(() => _isLoadingMore = false);
    context.showErrorSnackBar(message);
  }

  void _changePageSize(int pageSize) {
    if (pageSize == _selectedPageSize) return;

    setState(() {
      _selectedPageSize = pageSize;
      _extraNotes.clear();
      _hasMorePages = true;
      _isLoadingMore = false;
      _notesStream = widget.notesRepository.getNotes(limit: _streamLimit);
    });
  }
}

class _PageSizeSelector extends StatelessWidget {
  final int selectedPageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int> onChanged;

  const _PageSizeSelector({
    required this.selectedPageSize,
    required this.pageSizeOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          Text(
            NotesStrings.pageSizeLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<int>(
            value: selectedPageSize,
            borderRadius: BorderRadius.circular(12),
            items: pageSizeOptions
                .map(
                  (pageSize) => DropdownMenuItem<int>(
                    value: pageSize,
                    child: Text(_labelFor(pageSize)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }

  String _labelFor(int pageSize) {
    return switch (pageSize) {
      5 => NotesStrings.pageSizeFive,
      10 => NotesStrings.pageSizeTen,
      _ => NotesStrings.pageSizeAll,
    };
  }
}
