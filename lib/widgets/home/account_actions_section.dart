import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/controllers/home_actions_controller.dart';
import 'package:lr16_firebase_auth/dialogs/delete_account_dialog.dart';
import 'package:lr16_firebase_auth/dialogs/update_name_dialog.dart';
import 'package:lr16_firebase_auth/models/auth_result.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/utils/snack_bar_helper.dart';
import 'package:lr16_firebase_auth/widgets/action_tile.dart';

class AccountActionsSection extends StatefulWidget {
  final AuthStateRepository authStateRepository;
  final HomeActionsController controller;
  final VoidCallback? onAccountChanged;

  const AccountActionsSection({
    super.key,
    required this.authStateRepository,
    required this.controller,
    this.onAccountChanged,
  });

  @override
  State<AccountActionsSection> createState() => _AccountActionsSectionState();
}

class _AccountActionsSectionState extends State<AccountActionsSection> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final emailVerified = widget.authStateRepository.isEmailVerified;

    return Column(
      children: [
        ActionTile(
          icon: Icons.person_outline,
          title: HomeStrings.updateNameTitle,
          subtitle: HomeStrings.updateNameSubtitle,
          onTap: _updateDisplayName,
        ),
        const SizedBox(height: 8),
        if (!emailVerified) ...[
          ActionTile(
            icon: Icons.mark_email_unread_outlined,
            title: HomeStrings.verifyEmailTitle,
            subtitle: HomeStrings.verifyEmailSubtitle,
            onTap: _sendVerificationEmail,
          ),
          const SizedBox(height: 8),
        ],
        ActionTile(
          icon: Icons.delete_forever_outlined,
          title: HomeStrings.deleteAccountTitle,
          subtitle: HomeStrings.deleteAccountSubtitle,
          onTap: _deleteAccount,
          isDestructive: true,
        ),
      ],
    );
  }

  Future<void> _sendVerificationEmail() async {
    await _runAction(widget.controller.sendVerificationEmail);
  }

  Future<void> _updateDisplayName() async {
    final newName = await showUpdateNameDialog(
      context,
      initialName: widget.authStateRepository.currentDisplayName,
    );
    if (newName == null || !mounted) return;

    await _runAction(
      () => widget.controller.updateDisplayName(newName),
      successMessage: HomeStrings.nameUpdated,
      onSuccess: widget.onAccountChanged,
    );
  }

  Future<void> _deleteAccount() async {
    final password = await showDeleteAccountDialog(context);
    if (password == null || !mounted) return;

    await _runAction(() => widget.controller.deleteAccount(password));
  }

  Future<void> _runAction(
    Future<AuthResult> Function() action, {
    String? successMessage,
    VoidCallback? onSuccess,
  }) async {
    setState(() => _isLoading = true);
    final result = await action();
    if (!mounted) return;

    setState(() => _isLoading = false);
    _showResult(result, successMessage: successMessage);
    _handleSuccess(result, onSuccess);
  }

  void _handleSuccess(AuthResult result, VoidCallback? onSuccess) {
    if (onSuccess == null) return;

    switch (result) {
      case AuthSuccess():
      case AuthMessageSuccess():
        onSuccess();
        break;
      case AuthFailure():
        break;
    }
  }

  void _showResult(AuthResult result, {String? successMessage}) {
    switch (result) {
      case AuthSuccess():
        if (successMessage != null) {
          context.showSuccessSnackBar(successMessage);
        }
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
