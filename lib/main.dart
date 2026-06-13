import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/services/firebase_auth_service.dart';
import 'package:lr16_firebase_auth/services/firestore_service.dart';
import 'package:lr16_firebase_auth/services/storage_service.dart';
import 'package:lr16_firebase_auth/theme/app_theme.dart';
import 'package:lr16_firebase_auth/widgets/auth_wrapper.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final authRepository = FirebaseAuthService();
  final notesRepository = FirestoreService();
  final storageRepository = StorageService();

  runApp(
    MyApp(
      authRepository: authRepository,
      notesRepository: notesRepository,
      storageRepository: storageRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.notesRepository,
    required this.storageRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HomeStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      themeMode: ThemeMode.system,
      home: AuthWrapper(
        authRepository: authRepository,
        notesRepository: notesRepository,
        storageRepository: storageRepository,
      ),
    );
  }
}
