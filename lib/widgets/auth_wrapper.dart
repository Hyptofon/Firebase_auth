import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';
import 'package:lr16_firebase_auth/screens/home_screen.dart';
import 'package:lr16_firebase_auth/screens/login_screen.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';

class AuthWrapper extends StatelessWidget {
  final AuthRepository authRepository;
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;

  const AuthWrapper({
    super.key,
    required this.authRepository,
    required this.notesRepository,
    required this.storageRepository,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authRepository.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AuthStrings.loading,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AuthStrings.errorTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AuthStrings.errorRestart,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        final isSignedIn = snapshot.data ?? false;
        if (isSignedIn) {
          return HomeScreen(
            authRepository: authRepository,
            notesRepository: notesRepository,
            storageRepository: storageRepository,
          );
        }

        return LoginScreen(authRepository: authRepository);
      },
    );
  }
}
