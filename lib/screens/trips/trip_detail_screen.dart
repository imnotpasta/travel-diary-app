import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trip.dart';
import '../../models/memory.dart';
import '../../providers/trip_provider.dart';
import '../../services/weather_api_service.dart';
import '../../utils/formatters.dart';
import '../weather/weather_screen.dart';
import 'trip_form_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final WeatherApiService _weatherApiService = WeatherApiService();
  bool _isSyncing = false;

  void _showAddMemoryDialog(BuildContext context, int tripId) {
    final captionController = TextEditingController();
    final locationController = TextEditingController();
    final imageUrlController = TextEditingController(
      text: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    );
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thêm kỷ niệm ảnh mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL hình ảnh',
                    hintText: 'https://...',
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    labelText: 'Chú thích kỷ niệm',
                    hintText: 'Khoảnh khắc đáng nhớ...',
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Địa điểm chụp',
                    hintText: 'Ví dụ: Đỉnh Fansipan',
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Đánh giá:'),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          iconSize: 22,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (imageUrlController.text.trim().isEmpty) return;
                final memory = TripMemory(
                  tripId: tripId,
                  imagePath: imageUrlController.text.trim(),
                  caption: captionController.text.trim().isNotEmpty
                      ? captionController.text.trim()
                      : 'Kỷ niệm chuyến đi',
                  location: locationController.text.trim().isNotEmpty
                      ? locationController.text.trim()
                      : 'Địa điểm du lịch',
                  date: DateTime.now(),
                  rating: rating,
                );
                await context.read<TripProvider>().addMemory(memory);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  setState(() {});
                }
              },
              child: const Text('Lưu ảnh'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePostBackup(Trip trip) async {
    setState(() => _isSyncing = true);
    try {
      final res = await _weatherApiService.postTripBackupToServer(
        tripTitle: trip.title,
        destination: trip.destination,
        budget: trip.budget,
        travelerEmail: 'user@traveldiary.com',
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.cloud_done, color: Colors.green, size: 48),
            title: const Text('REST API POST Thành công!'),
            content: Text(
              '${res['serverMessage']}\n\n'
              '• Server Backend: reqres.in\n'
              '• HTTP Status: 201 Created\n'
              '• Server ID: ${res['data']['id'] ?? 'auto-gen'}\n'
              '• Thời gian server: ${res['data']['createdAt'] ?? DateTime.now().toString()}',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi gửi HTTP POST: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final tripList = tripProvider.trips.where((t) => t.id == widget.tripId).toList();

    if (tripList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết chuyến đi')),
        body: const Center(child: Text('Không tìm thấy thông tin chuyến đi!')),
      );
    }

    final trip = tripList.first;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar dạng Sliver với ảnh bìa mở rộng
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                trip.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                ),
              ),
              background: trip.coverImage != null && trip.coverImage!.isNotEmpty
                  ? Image.network(
                      trip.coverImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.teal),
                    )
                  : Container(color: Colors.teal),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripFormScreen(tripToEdit: trip),
                    ),
                  );
                },
              ),
            ],
          ),

          // Nội dung chi tiết chuyến đi
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thẻ thông tin tóm tắt
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            Icons.location_on,
                            Colors.teal,
                            'Địa điểm',
                            trip.destination,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            Icons.calendar_month,
                            Colors.orange,
                            'Khởi hành',
                            Formatters.formatDate(trip.startDate),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            Icons.payments,
                            Colors.green,
                            'Dự trù chi phí',
                            Formatters.formatCurrency(trip.budget),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nút hành động nhanh: Xem thời tiết & Đồng bộ REST API POST
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WeatherScreen(prefilledCity: trip.destination),
                              ),
                            );
                          },
                          icon: const Icon(Icons.wb_sunny_outlined, color: Colors.amber),
                          label: const Text('Xem Thời tiết', style: TextStyle(fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isSyncing ? null : () => _handlePostBackup(trip),
                          icon: _isSyncing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                          label: const Text('Sync HTTP POST', style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Lịch trình chi tiết
                  const Text(
                    'Lịch trình chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        trip.itinerary,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bộ sưu tập ảnh & kỷ niệm của chuyến đi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Album ảnh kỷ niệm (Sqflite)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddMemoryDialog(context, trip.id!),
                        icon: const Icon(Icons.add_a_photo, size: 18),
                        label: const Text('Thêm ảnh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  FutureBuilder<List<TripMemory>>(
                    future: tripProvider.getMemoriesForTrip(trip.id!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final memories = snapshot.data!;
                      if (memories.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          child: const Text(
                            'Chưa có ảnh nào cho chuyến đi này.\nNhấn "Thêm ảnh" để lưu giữ khoảnh khắc!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: memories.length,
                        itemBuilder: (context, index) {
                          final mem = memories[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      mem.imagePath,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image_not_supported),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mem.caption,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on, size: 14, color: Colors.teal),
                                            const SizedBox(width: 4),
                                            Text(mem.location, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (starIdx) => Icon(
                                              starIdx < mem.rating ? Icons.star : Icons.star_border,
                                              size: 14,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () async {
                                      await tripProvider.deleteMemory(mem.id!);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, Color iconColor, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

