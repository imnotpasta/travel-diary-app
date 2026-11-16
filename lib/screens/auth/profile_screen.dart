import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/theme_provider.dart';
import '../../providers/trip_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_image.dart';
import '../../widgets/image_picker_widget.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  void _showEditProfileDialog(AppUser user) {
    final nameCtrl = TextEditingController(text: user.displayName);
    final cityCtrl = TextEditingController(text: user.homeCity);
    final bioCtrl = TextEditingController(text: user.bio);
    String selectedPhoto = user.photoUrl ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cập nhật Hồ sơ Du khách'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImagePickerWidget(
                label: 'Ảnh đại diện (Avatar)',
                initialImage: selectedPhoto,
                convertToBase64ForCloud: true,
                onImageSelected: (path) {
                  selectedPhoto = path;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên hiển thị'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(labelText: 'Thành phố cư trú'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Tiểu sử / Châm ngôn du lịch'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              await _authService.updateProfile(
                displayName: nameCtrl.text.trim(),
                homeCity: cityCtrl.text.trim(),
                bio: bioCtrl.text.trim(),
                photoUrl: selectedPhoto.isNotEmpty ? selectedPhoto : user.photoUrl,
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final tripProvider = context.watch<TripProvider>();

    return Scaffold(
      body: StreamBuilder<AppUser?>(
        // Tiêu chí Đề tài 10: duy trì phiên authStateChanges()
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data ?? _authService.currentUser;

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 72, color: Colors.teal),
                  const SizedBox(height: 16),
                  const Text('Bạn chưa đăng nhập tài khoản du khách'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text('Đăng nhập / Đăng ký'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Avatar và Tên
                ClipOval(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: AppImage(
                      imagePath: user.photoUrl ?? '',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorWidget: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.displayName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.home, size: 16, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        user.homeCity,
                        style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '"${user.bio}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                // Thống kê du lịch
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Chuyến đi',
                        '${tripProvider.trips.length}',
                        Icons.flight_takeoff,
                        Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildStatCard(
                        'Kỷ niệm ảnh',
                        '${tripProvider.allMemories.length}',
                        Icons.photo_camera_back,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Cài đặt giao diện Dark / Light Mode (Tiêu chí 1: Hỗ trợ Dark/Light Theme)
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.amber,
                        ),
                        title: const Text('Giao diện Tối (Dark Theme)'),
                        subtitle: Text(
                          themeProvider.isDarkMode ? 'Đang bật Dark Mode' : 'Đang bật Light Mode',
                          style: const TextStyle(fontSize: 12),
                        ),
                        value: themeProvider.isDarkMode,
                        onChanged: (val) => themeProvider.toggleTheme(val),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.edit_outlined, color: Colors.teal),
                        title: const Text('Chỉnh sửa thông tin cá nhân'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showEditProfileDialog(user),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.verified_user_outlined, color: Colors.green),
                        title: const Text('Trạng thái xác thực Firebase'),
                        subtitle: const Text('Đã xác thực & duy trì phiên authStateChanges()', style: TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text('Đăng xuất tài khoản', style: TextStyle(color: Colors.redAccent)),
                        onTap: () async {
                          await _authService.signOut();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã đăng xuất tài khoản')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
