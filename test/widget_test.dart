import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr16_firebase_auth/screens/profile_screen.dart';
import 'package:lr16_firebase_auth/constants/auth_strings.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/widgets/auth_wrapper.dart';
import 'fakes/fake_auth_repository.dart';
import 'fakes/fake_notes_repository.dart';
import 'fakes/fake_storage_repository.dart';

void main() {
  testWidgets('AuthWrapper shows login screen when user is signed out', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthWrapper(
          authRepository: FakeAuthRepository(signedIn: false),
          notesRepository: FakeNotesRepository(),
          storageRepository: FakeStorageRepository(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text(AuthStrings.loginTitle), findsOneWidget);
    expect(find.text(AuthStrings.loginButton), findsOneWidget);
  });

  testWidgets('AuthWrapper shows home screen when user is signed in', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthWrapper(
          authRepository: FakeAuthRepository(
            signedIn: true,
            displayName: 'Test User',
            email: 'test@example.com',
          ),
          notesRepository: FakeNotesRepository(),
          storageRepository: FakeStorageRepository(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Hello, Test User!'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text(HomeStrings.viewProfileTitle), findsOneWidget);
    expect(find.text(HomeStrings.settingsTitle), findsOneWidget);
  });

  testWidgets('ProfileScreen blocks unauthenticated access', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          authStateRepository: FakeAuthRepository(signedIn: false),
        ),
      ),
    );

    expect(find.text(HomeStrings.protectedAccessDenied), findsOneWidget);
  });
}
