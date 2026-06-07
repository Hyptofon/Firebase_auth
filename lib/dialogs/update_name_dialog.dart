import 'package:flutter/material.dart';
import '../utils/validators.dart';

Future<String?> showUpdateNameDialog(
  BuildContext context, {
  String? initialName,
}) async {
  final newName = await showDialog<String>(
    context: context,
    builder: (context) => _UpdateNameDialog(initialName: initialName),
  );

  return (newName == null || newName.isEmpty) ? null : newName;
}

class _UpdateNameDialog extends StatefulWidget {
  final String? initialName;

  const _UpdateNameDialog({this.initialName});

  @override
  State<_UpdateNameDialog> createState() => _UpdateNameDialogState();
}

class _UpdateNameDialogState extends State<_UpdateNameDialog> {
  late final TextEditingController _nameController;

  bool _hasSubmitted = false;
  bool _canSubmit = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _nameController.addListener(_updateCanSubmit);
    _canSubmit = _nameController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateCanSubmit);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Name'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Display Name',
          prefixIcon: Icon(
            Icons.person_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          errorText: _hasSubmitted ? _errorText : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _canSubmit ? _submit : null,
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_canSubmit) return;

    final errorText = _validateName();
    setState(() {
      _hasSubmitted = true;
      _errorText = errorText;
    });

    if (errorText == null) {
      Navigator.pop(context, _nameController.text.trim());
    }
  }

  void _updateCanSubmit() {
    final canSubmit = _nameController.text.trim().isNotEmpty;

    final errorText = _hasSubmitted ? _validateName() : _errorText;

    if (canSubmit == _canSubmit && errorText == _errorText) return;
    setState(() {
      _canSubmit = canSubmit;
      _errorText = errorText;
    });
  }

  String? _validateName() {
    return Validators.compose([
      (v) => Validators.required(v, fieldName: 'Name'),
      Validators.name,
    ])(_nameController.text);
  }
}
