import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/widgets/protected_access_denied.dart';

class ProtectedRoute extends StatelessWidget {
  final AuthStateRepository authStateRepository;
  final String title;
  final Widget child;

  const ProtectedRoute({
    super.key,
    required this.authStateRepository,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!authStateRepository.isSignedIn) {
      return ProtectedAccessDenied(title: title);
    }

    return child;
  }
}
