import 'package:flutter/material.dart';
import '../../models/community_post.dart';
import '../../services/auth_service.dart';
import '../../services/realtime_db_service.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_image.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final RealtimeDbService _realtimeDbService = RealtimeDbService();
  final AuthService _authService = AuthService();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    final user = _authService.currentUser;

    final comment = PostComment(
      id: 'cmt_${DateTime.now().millisecondsSinceEpoch}',
      authorName: user?.displayName ?? 'Du khách khám phá',
      authorAvatar: user?.photoUrl ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
      text: text,
      createdAt: DateTime.now(),
    );

    await _realtimeDbService.addComment(widget.postId, comment);
    _commentController.clear();

    if (mounted) {
      setState(() => _isSending = false);
      // Cuộn xuống cuối danh sách bình luận
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết & Bình luận Realtime'),
      ),
      body: StreamBuilder<CommunityPost?>(
        // Luồng theo dõi thời gian thực bài viết & bình luận
        stream: _realtimeDbService.watchPostDetail(widget.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final post = snapshot.data;
          if (post == null) {
            return const Center(child: Text('Bài viết không tồn tại hoặc đã bị gỡ!'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Tác giả & Thời gian
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(post.authorAvatar),
                          onBackgroundImageError: (_, __) {},
                          child: post.authorAvatar.isEmpty ? const Icon(Icons.person) : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              '${post.destination} • ${Formatters.formatDateTime(post.createdAt)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tiêu đề & Nội dung
                    Text(
                      post.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    // Ảnh kỷ niệm địa điểm
                    if (post.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AppImage(
                          imagePath: post.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: const SizedBox(),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Tương tác like
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.redAccent),
                          onPressed: () => _realtimeDbService.toggleLike(post.id),
                        ),
                        Text('${post.likes} lượt thích', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 32),

                    // Danh sách bình luận thời gian thực
                    Row(
                      children: [
                        const Icon(Icons.chat, size: 18, color: Colors.teal),
                        const SizedBox(width: 6),
                        Text(
                          'Bình luận thời gian thực (${post.comments.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (post.comments.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        alignment: Alignment.center,
                        child: const Text('Chưa có bình luận nào. Hãy gửi lời chào đầu tiên!', style: TextStyle(color: Colors.grey)),
                      )
                    else
                      ...post.comments.map((comment) => _buildCommentItem(comment)),
                  ],
                ),
              ),

              // Thanh nhập bình luận thời gian thực
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2)),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Nhập bình luận realtime...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onSubmitted: (_) => _sendComment(),
                        ),
                      ),
                      IconButton(
                        icon: _isSending
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send, color: Colors.teal),
                        onPressed: _isSending ? null : _sendComment,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCommentItem(PostComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.authorAvatar),
            onBackgroundImageError: (_, __) {},
            child: comment.authorAvatar.isEmpty ? const Icon(Icons.person, size: 16) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        Formatters.formatDateTime(comment.createdAt),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.text, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
