import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LocalImagePreview extends StatefulWidget {
  final XFile file;

  const LocalImagePreview({super.key, required this.file});

  @override
  State<LocalImagePreview> createState() => _LocalImagePreviewState();
}

class _LocalImagePreviewState extends State<LocalImagePreview> {
  late Future<Uint8List> _bytesFuture;

  @override
  void initState() {
    super.initState();
    _bytesFuture = _readSelectedImage();
  }

  @override
  void didUpdateWidget(covariant LocalImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.file.path != widget.file.path ||
        oldWidget.file.name != widget.file.name) {
      _bytesFuture = _readSelectedImage();
    }
  }

  Future<Uint8List> _readSelectedImage() {
    return widget.file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FutureBuilder<Uint8List>(
        future: _bytesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          }

          if (snapshot.hasError) {
            return _ImageFallback(
              colorScheme: colorScheme,
              icon: Icons.broken_image_outlined,
            );
          }

          return _ImageFallback(
            colorScheme: colorScheme,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
      ),
    );
  }
}

class NetworkImagePreview extends StatelessWidget {
  final String imageUrl;
  final double height;

  const NetworkImagePreview({
    super.key,
    required this.imageUrl,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            alignment: Alignment.center,
            color: colorScheme.surfaceContainerHighest,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _ImageFallback(
            colorScheme: colorScheme,
            icon: Icons.broken_image_outlined,
            height: height,
          );
        },
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final ColorScheme colorScheme;
  final IconData? icon;
  final Widget? child;
  final double height;

  const _ImageFallback({
    required this.colorScheme,
    this.icon,
    this.child,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      color: colorScheme.surfaceContainerHighest,
      child: child ?? Icon(icon, color: colorScheme.onSurfaceVariant, size: 48),
    );
  }
}
