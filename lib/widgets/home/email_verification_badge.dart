import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/home_strings.dart';

class EmailVerificationBadge extends StatelessWidget {
  final bool isVerified;

  const EmailVerificationBadge({super.key, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isVerified
            ? colorScheme.tertiaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified : Icons.warning_amber_rounded,
            size: 18,
            color: isVerified ? colorScheme.tertiary : colorScheme.error,
          ),
          const SizedBox(width: 6),
          Text(
            isVerified
                ? HomeStrings.emailVerified
                : HomeStrings.emailNotVerified,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isVerified
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
