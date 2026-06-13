import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/widgets/protected_route.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';

class SettingsScreen extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const SettingsScreen({super.key, required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    return ProtectedRoute(
      authStateRepository: authStateRepository,
      title: HomeStrings.settingsTitle,
      child: Scaffold(
        appBar: AppBar(title: const Text(HomeStrings.settingsTitle)),
        body: _SettingsBody(authStateRepository: authStateRepository),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const _SettingsBody({required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const _SettingsTile(
          icon: Icons.lock_outline,
          title: HomeStrings.protectedRouteTile,
          subtitle: HomeStrings.protectedRouteSubtitle,
          value: HomeStrings.protectedRouteActive,
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.sync_outlined,
          title: HomeStrings.authPersistenceTile,
          subtitle: HomeStrings.authPersistenceSubtitle,
          value: authStateRepository.isSignedIn
              ? HomeStrings.signedIn
              : HomeStrings.signedOut,
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.email_outlined,
          title: HomeStrings.currentAccountTile,
          subtitle: authStateRepository.currentEmail ?? HomeStrings.noEmail,
          value: authStateRepository.isEmailVerified
              ? HomeStrings.verified
              : HomeStrings.unverified,
        ),
      ],
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
