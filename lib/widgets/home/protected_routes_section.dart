import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import '../../screens/profile_screen.dart';
import '../../screens/settings_screen.dart';
import '../action_tile.dart';

class ProtectedRoutesSection extends StatelessWidget {
  final AuthStateRepository authStateRepository;

  const ProtectedRoutesSection({super.key, required this.authStateRepository});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionTile(
          icon: Icons.badge_outlined,
          title: 'View Profile',
          subtitle: 'Open protected profile screen',
          onTap: () => _open(
            context,
            ProfileScreen(authStateRepository: authStateRepository),
          ),
        ),
        const SizedBox(height: 8),
        ActionTile(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'Open protected settings screen',
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
