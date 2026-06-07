import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../widgets/protected_route.dart';

class SettingsScreen extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const SettingsScreen({super.key, required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    return ProtectedRoute(
      authStateRepository: authStateRepository,
      title: 'Settings',
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Protected route',
              subtitle: 'Only authenticated users can open this screen',
              value: 'Active',
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.sync_outlined,
              title: 'Auth state persistence',
              subtitle: 'Firebase keeps the user session between app launches',
              value: authStateRepository.isSignedIn
                  ? 'Signed in'
                  : 'Signed out',
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.email_outlined,
              title: 'Current account',
              subtitle: authStateRepository.currentEmail ?? 'No email',
              value: authStateRepository.isEmailVerified
                  ? 'Verified'
                  : 'Unverified',
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
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
        subtitle: Text(subtitle),
        trailing: Text(
          value,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
