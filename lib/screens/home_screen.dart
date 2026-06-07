import 'package:flutter/material.dart';
import '../controllers/home_actions_controller.dart';
import '../repositories/auth_repository.dart';
import '../widgets/home/account_actions_section.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/logout_button.dart';
import '../widgets/home/protected_routes_section.dart';
import '../widgets/home/session_card.dart';

class HomeScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const HomeScreen({super.key, required this.authRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _refreshAccountInfo() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = HomeActionsController(
      authCredentialsRepository: widget.authRepository,
      accountRepository: widget.authRepository,
      authStateRepository: widget.authRepository,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [LogoutButton(controller: controller)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            HomeHeader(authStateRepository: widget.authRepository),
            const SizedBox(height: 32),
            const SessionCard(),
            const SizedBox(height: 32),
            _SectionTitle(title: 'Protected Screens'),
            const SizedBox(height: 16),
            ProtectedRoutesSection(authStateRepository: widget.authRepository),
            const SizedBox(height: 32),
            _SectionTitle(title: 'Account Actions'),
            const SizedBox(height: 16),
            AccountActionsSection(
              authStateRepository: widget.authRepository,
              controller: controller,
              onAccountChanged: _refreshAccountInfo,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
