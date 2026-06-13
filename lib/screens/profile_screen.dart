import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/widgets/protected_route.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';

class ProfileScreen extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const ProfileScreen({super.key, required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    return ProtectedRoute(
      authStateRepository: authStateRepository,
      title: HomeStrings.profileAppBar,
      child: Scaffold(
        appBar: AppBar(title: const Text(HomeStrings.profileAppBar)),
        body: _ProfileBody(authStateRepository: authStateRepository),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const _ProfileBody({required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    final displayName =
        authStateRepository.currentDisplayName ?? HomeStrings.defaultUserName;
    final email = authStateRepository.currentEmail ?? HomeStrings.noEmail;
    final isEmailVerified = authStateRepository.isEmailVerified;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 44,
          child: Text(
            displayName.trim().isNotEmpty
                ? displayName.trim()[0].toUpperCase()
                : HomeStrings.defaultAvatarLetter,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 24),
        _ProfileInfoTile(
          icon: Icons.person_outline,
          title: HomeStrings.displayNameTile,
          value: displayName,
        ),
        const SizedBox(height: 12),
        _ProfileInfoTile(
          icon: Icons.email_outlined,
          title: HomeStrings.emailTile,
          value: email,
        ),
        const SizedBox(height: 12),
        _ProfileInfoTile(
          icon: isEmailVerified
              ? Icons.verified_user_outlined
              : Icons.mark_email_unread_outlined,
          title: HomeStrings.emailStatusTile,
          value: isEmailVerified
              ? HomeStrings.verified
              : HomeStrings.notVerified,
        ),
      ],
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
