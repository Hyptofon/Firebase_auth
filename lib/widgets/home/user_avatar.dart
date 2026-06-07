import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? displayName;
  final String? email;
  final Animation<double> scaleAnimation;

  const UserAvatar({
    super.key,
    required this.displayName,
    required this.email,
    required this.scaleAnimation,
  });

  String get _initial {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName![0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: scaleAnimation,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          _initial,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
