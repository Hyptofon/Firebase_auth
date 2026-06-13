import 'package:lr16_firebase_auth/repositories/notes_reader_repository.dart';
import 'package:lr16_firebase_auth/repositories/notes_writer_repository.dart';

abstract class NotesRepository
    implements NotesReaderRepository, NotesWriterRepository {}
