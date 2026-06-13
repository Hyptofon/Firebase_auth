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

class AnimatedAuthContent extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;

  const AnimatedAuthContent({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.beginOffset = Offset.zero,
  });

  @override
  State<AnimatedAuthContent> createState() => _AnimatedAuthContentState();
}

class _AnimatedAuthContentState extends State<AnimatedAuthContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
