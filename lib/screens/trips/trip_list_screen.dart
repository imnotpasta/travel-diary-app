import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import 'trip_detail_screen.dart';
import 'trip_form_screen.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, Trip trip) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa chuyến đi "${trip.title}" cùng toàn bộ kỷ niệm ảnh đi kèm không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final tripProvider = context.read<TripProvider>();
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              await tripProvider.deleteTrip(trip.id!);
              messenger.showSnackBar(
                SnackBar(content: Text('Đã xóa thành công "${trip.title}"')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final trips = tripProvider.trips;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Thanh tìm kiếm chuyến đi cục bộ
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm chuyến đi theo tên hoặc địa điểm...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          tripProvider.searchTrips('');
                        },
                      )
                    : null,
              ),
              onChanged: (val) => tripProvider.searchTrips(val),
            ),
          ),

          // Danh sách chuyến đi Offline (Sqflite)
          Expanded(
            child: tripProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : trips.isEmpty
                    ? EmptyState(
                        icon: Icons.card_travel,
                        title: 'Chưa có chuyến đi nào',
                        message: 'Lên kế hoạch và lưu giữ những hành trình tuyệt vời ngay hôm nay!',
                        actionText: 'Tạo chuyến đi mới',
                        onAction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TripFormScreen()),
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => tripProvider.loadTrips(),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            final trip = trips[index];
                            return _buildTripCard(context, trip, isDark);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TripFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm chuyến đi'),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, Trip trip, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripDetailScreen(tripId: trip.id!),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh bìa chuyến đi
                if (trip.coverImage != null && trip.coverImage!.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      trip.coverImage!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 120,
                        color: Colors.teal.withOpacity(0.2),
                        child: const Center(
                          child: Icon(Icons.landscape, size: 50, color: Colors.teal),
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              trip.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (val) {
                              if (val == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TripFormScreen(tripToEdit: trip),
                                  ),
                                );
                              } else if (val == 'delete') {
                                _confirmDelete(context, trip);
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Chỉnh sửa'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Xóa', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Địa điểm
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              trip.destination,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Ngày khởi hành & Chi phí dự trù dùng FittedBox và Responsive wrap
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                Formatters.formatDate(trip.startDate),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Dự trù: ${Formatters.formatCurrency(trip.budget)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
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
      },
    );
  }
}

