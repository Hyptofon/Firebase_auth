import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/screens/profile_screen.dart';
import 'package:lr16_firebase_auth/screens/settings_screen.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/widgets/action_tile.dart';

class ProtectedRoutesSection extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const ProtectedRoutesSection({super.key, required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionTile(
          icon: Icons.badge_outlined,
          title: HomeStrings.viewProfileTitle,
          subtitle: HomeStrings.viewProfileSubtitle,
          onTap: () => _open(
            context,
            ProfileScreen(authStateRepository: authStateRepository),
          ),
        ),
        const SizedBox(height: 8),
        ActionTile(
          icon: Icons.settings_outlined,
          title: HomeStrings.settingsTitle,
          subtitle: HomeStrings.settingsSubtitle,
          onTap: () => _open(
            context,
            SettingsScreen(authStateRepository: authStateRepository),
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
