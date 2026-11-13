import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/memory.dart';
import '../../providers/trip_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';

class AlbumGridScreen extends StatelessWidget {
  const AlbumGridScreen({super.key});

  void _showImageDetail(BuildContext context, TripMemory memory) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                memory.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(ctx).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.caption,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.teal),
                      const SizedBox(width: 4),
                      Text(memory.location, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const Spacer(),
                      Text(Formatters.formatDate(memory.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final memories = tripProvider.allMemories;

    // Yêu cầu bắt buộc 1: MediaQuery lấy kích thước và padding an toàn của thiết bị
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      body: memories.isEmpty
          ? const EmptyState(
              icon: Icons.photo_library_outlined,
              title: 'Bộ sưu tập trống',
              message: 'Hãy thêm các chuyến đi và lưu lại những bức ảnh kỷ niệm tuyệt đẹp nhé!',
            )
          : LayoutBuilder(
              // Yêu cầu bắt buộc 2: LayoutBuilder xác định ràng buộc không gian hiển thị
              builder: (context, constraints) {
                return OrientationBuilder(
                  // Yêu cầu bắt buộc 3: OrientationBuilder tự động chuyển đổi:
                  // 2 cột khi xoay đứng (portrait) hoặc 3 cột khi xoay ngang (landscape)
                  builder: (context, orientation) {
                    final int crossAxisCount = orientation == Orientation.portrait ? 2 : 3;

                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Lưới Album Ảnh Kỷ Niệm',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${memories.length} khoảnh khắc được lưu giữ',
                                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                // Yêu cầu bắt buộc 4: FittedBox co giãn huy hiệu chế độ xoay mà không tràn chữ
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isLandscape ? Icons.screen_lock_landscape : Icons.screen_lock_portrait,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          orientation == Orientation.portrait ? '2 Cột (Đứng)' : '3 Cột (Ngang)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Lưới GridView.builder Responsive
                        SliverPadding(
                          padding: const EdgeInsets.all(12),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final memory = memories[index];
                                return _buildMemoryTile(context, memory);
                              },
                              childCount: memories.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildMemoryTile(BuildContext context, TripMemory memory) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => _showImageDetail(context, memory),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    memory.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            memory.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.caption,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.teal),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          memory.location,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

