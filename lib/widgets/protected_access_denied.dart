import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/home_strings.dart';

class ProtectedAccessDenied extends StatelessWidget {
  final String title;

  const ProtectedAccessDenied({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 72, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                HomeStrings.protectedAccessDenied,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
