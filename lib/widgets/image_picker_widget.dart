import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_image.dart';

/// Widget chọn ảnh trực tiếp từ Thư viện máy hoặc Chụp ảnh từ Camera
/// Hỗ trợ nén ảnh và chuyển thành Base64 Data URI để đồng bộ Cloud hoặc lưu máy.
class ImagePickerWidget extends StatefulWidget {
  final String? initialImage;
  final ValueChanged<String> onImageSelected;
  final String label;
  final bool convertToBase64ForCloud;

  const ImagePickerWidget({
    super.key,
    this.initialImage,
    required this.onImageSelected,
    this.label = 'Hình ảnh',
    this.convertToBase64ForCloud = false,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  String _currentImage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.initialImage ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isLoading = true);
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 75,
      );

      if (file != null) {
        String finalPath = file.path;
        if (widget.convertToBase64ForCloud) {
          final bytes = await file.readAsBytes();
          final base64String = base64Encode(bytes);
          finalPath = 'data:image/jpeg;base64,$base64String';
        }

        setState(() {
          _currentImage = finalPath;
        });
        widget.onImageSelected(finalPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể chọn ảnh: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showUrlInputDialog() {
    final urlCtrl = TextEditingController(text: _currentImage.startsWith('http') ? _currentImage : '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dán liên kết URL ảnh'),
        content: TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(
            labelText: 'URL ảnh',
            hintText: 'https://...',
            prefixIcon: Icon(Icons.link),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              final text = urlCtrl.text.trim();
              if (text.isNotEmpty) {
                setState(() => _currentImage = text);
                widget.onImageSelected(text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _showUrlInputDialog,
              icon: const Icon(Icons.link, size: 16),
              label: const Text('Dán link URL', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Khung hiển thị trước ảnh đã chọn
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentImage.isNotEmpty
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(imagePath: _currentImage, fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 16,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                onPressed: () {
                                  setState(() => _currentImage = '');
                                  widget.onImageSelected('');
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 48, color: Colors.teal.withValues(alpha: 0.7)),
                            const SizedBox(height: 8),
                            const Text(
                              'Chưa có ảnh nào được chọn',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
        const SizedBox(height: 10),

        // Các nút bấm chọn ảnh trực tiếp
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text('Thư viện máy'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt, size: 18),
                label: const Text('Chụp ảnh mới'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
