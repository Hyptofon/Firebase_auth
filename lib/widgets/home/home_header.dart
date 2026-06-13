import 'package:flutter/material.dart';

import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'email_verification_badge.dart';
import 'user_avatar.dart';

class HomeHeader extends StatefulWidget {
  final String? displayName;
  final String? email;
  final bool isEmailVerified;

  const HomeHeader({
    super.key,
    this.displayName,
    this.email,
    required this.isEmailVerified,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = widget.displayName;
    final email = widget.email ?? '';
    final emailVerified = widget.isEmailVerified;

    return Column(
      children: [
        UserAvatar(
          displayName: displayName,
          email: email,
          scaleAnimation: _scaleAnimation,
        ),
        const SizedBox(height: 20),
        Text(
          HomeStrings.greetingText(displayName),
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        EmailVerificationBadge(isVerified: emailVerified),
      ],
    );
  }
}
