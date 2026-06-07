import 'package:flutter/material.dart';

class AuthScreenLayout extends StatelessWidget {
  final Widget child;
  final double mobileTopSpacing;

  const AuthScreenLayout({
    super.key,
    required this.child,
    this.mobileTopSpacing = 24,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;
          final horizontalPadding = isWide ? 32.0 : 24.0;
          final verticalPadding = isWide ? 48.0 : 0.0;
          final availableHeight = constraints.maxHeight - verticalPadding * 2;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: availableHeight > 0 ? availableHeight : 0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: isWide
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.45,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withValues(
                                  alpha: 0.12,
                                ),
                                blurRadius: 28,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: child,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                            top: mobileTopSpacing,
                            bottom: 24,
                          ),
                          child: child,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
