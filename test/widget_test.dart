import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr16_firebase_auth/screens/profile_screen.dart';
import 'package:lr16_firebase_auth/widgets/auth_wrapper.dart';
import 'fakes/fake_auth_repository.dart';

void main() {
  testWidgets('AuthWrapper shows login screen when user is signed out', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthWrapper(authRepository: FakeAuthRepository(signedIn: false)),
      ),
    );

    await tester.pump();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
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
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Hello, Test User!'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('View Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('ProfileScreen blocks unauthenticated access', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          authStateRepository: FakeAuthRepository(signedIn: false),
        ),
      ),
    );

    expect(find.text('Please login to view this screen'), findsOneWidget);
  });
}
