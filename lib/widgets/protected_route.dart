import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import 'protected_access_denied.dart';

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
