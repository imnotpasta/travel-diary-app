import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Component hiển thị hình ảnh đa năng:
/// 1. URL Web (http / https)
/// 2. Ảnh Base64 Data URI (data:image/...)
/// 3. File cục bộ từ bộ nhớ máy điện thoại (chọn từ Gallery / Camera)
class AppImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.trim().isEmpty) {
      return _buildPlaceholder();
    }

    final trimmed = imagePath.trim();

    // 1. Chuỗi Data URI hoặc Base64
    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Str = commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        );
      } catch (_) {
        return _buildPlaceholder();
      }
    }

    // 2. Đường dẫn URL Internet (http / https)
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Image.network(
        trimmed,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey.withValues(alpha: 0.1),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }

    // 3. File cục bộ từ bộ nhớ máy (Android / iOS)
    if (!kIsWeb) {
      try {
        final file = File(trimmed);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          );
        }
      } catch (_) {}
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey.withValues(alpha: 0.15),
          child: const Center(
            child: Icon(Icons.image, size: 36, color: Colors.grey),
          ),
        );
  }
}
