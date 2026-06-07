import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../widgets/protected_route.dart';

class ProfileScreen extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const ProfileScreen({super.key, required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    final displayName = authStateRepository.currentDisplayName ?? 'User';
    final email = authStateRepository.currentEmail ?? 'No email';
    final isEmailVerified = authStateRepository.isEmailVerified;

    return ProtectedRoute(
      authStateRepository: authStateRepository,
      title: 'Profile',
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CircleAvatar(
              radius: 44,
              child: Text(
                displayName.trim().isNotEmpty
                    ? displayName.trim()[0].toUpperCase()
                    : 'U',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 24),
            _ProfileInfoTile(
              icon: Icons.person_outline,
              title: 'Display name',
              value: displayName,
            ),
            const SizedBox(height: 12),
            _ProfileInfoTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: email,
            ),
            const SizedBox(height: 12),
            _ProfileInfoTile(
              icon: isEmailVerified
                  ? Icons.verified_user_outlined
                  : Icons.mark_email_unread_outlined,
              title: 'Email status',
              value: isEmailVerified ? 'Verified' : 'Not verified',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
