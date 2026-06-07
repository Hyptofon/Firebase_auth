import 'package:flutter/material.dart';
import '../../controllers/home_actions_controller.dart';
import '../../dialogs/logout_dialog.dart';
import '../../models/auth_result.dart';
import '../../utils/snack_bar_helper.dart';

class LogoutButton extends StatelessWidget {
  final HomeActionsController controller;

  const LogoutButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: () => _logout(context),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showLogoutDialog(context);
    if (!confirmed || !context.mounted) return;

    final result = await controller.logout();
    if (!context.mounted) return;

    switch (result) {
      case AuthSuccess():
        break;
      case AuthMessageSuccess(:final message):
        context.showInfoSnackBar(message);
        break;
      case AuthFailure(:final message):
        context.showErrorSnackBar(message);
        break;
    }
  }
}
