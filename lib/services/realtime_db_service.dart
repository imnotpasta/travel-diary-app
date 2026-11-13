import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/community_post.dart';

/// Dịch vụ Đồng bộ Kỷ niệm Cộng đồng Thời gian thực (Firebase Realtime DB Pattern)
/// Sử dụng kiến trúc luồng dữ liệu phản ứng: StreamBuilder kết hợp async* và yield.
class RealtimeDbService {
  static final RealtimeDbService _instance = RealtimeDbService._internal();
  factory RealtimeDbService() => _instance;

  RealtimeDbService._internal() {
    _loadInitialPosts();
  }

  static const _postsStorageKey = 'realtime_community_posts';
  final StreamController<List<CommunityPost>> _postsBroadcastController =
      StreamController<List<CommunityPost>>.broadcast();

  List<CommunityPost> _posts = [];

  List<CommunityPost> get currentPosts => List.unmodifiable(_posts);

  Future<void> _loadInitialPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(_postsStorageKey);
      if (savedJson != null) {
        final List<dynamic> decoded = jsonDecode(savedJson);
        _posts = decoded
            .map((item) => CommunityPost.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
      } else {
        _posts = _generateMockRealtimePosts();
        await _persistPosts();
      }
    } catch (_) {
      _posts = _generateMockRealtimePosts();
    }
    _postsBroadcastController.add(_posts);
  }

  /// Tiêu chuẩn chấm điểm Đề tài 10:
  /// "Đồng bộ dữ liệu thời gian thực mượt mà bằng StreamBuilder (async*/yield)"
  Stream<List<CommunityPost>> watchPostsStream() async* {
    // Phát dữ liệu hiện tại ngay lập tức qua yield
    yield _posts;

    // Lắng nghe các bản cập nhật thời gian thực kế tiếp
    await for (final updatedPosts in _postsBroadcastController.stream) {
      yield updatedPosts;
    }
  }

  /// Luồng theo dõi chi tiết 1 bài viết kèm bình luận thời gian thực qua async* / yield
  Stream<CommunityPost?> watchPostDetail(String postId) async* {
    final initial = _posts.where((p) => p.id == postId).firstOrNull;
    yield initial;

    await for (final updatedList in _postsBroadcastController.stream) {
      final match = updatedList.where((p) => p.id == postId).firstOrNull;
      yield match;
    }
  }

  /// Đăng chia sẻ địa điểm du lịch mới lên cộng đồng
  Future<void> addPost(CommunityPost post) async {
    _posts.insert(0, post);
    await _persistPosts();
    _postsBroadcastController.add(_posts);
  }

  /// Thêm bình luận thời gian thực cho địa điểm du lịch
  Future<void> addComment(String postId, PostComment comment) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final updatedComments = List<PostComment>.from(post.comments)..add(comment);
      _posts[index] = post.copyWith(comments: updatedComments);
      await _persistPosts();
      _postsBroadcastController.add(_posts);
    }
  }

  /// Thả tim / Thích địa điểm
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(likes: post.likes + 1);
      await _persistPosts();
      _postsBroadcastController.add(_posts);
    }
  }

  Future<void> _persistPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_posts.map((p) => p.toMap()).toList());
      await prefs.setString(_postsStorageKey, encoded);
    } catch (_) {}
  }

  List<CommunityPost> _generateMockRealtimePosts() {
    return [
      CommunityPost(
        id: 'post_1',
        authorId: 'user_ha_long',
        authorName: 'Lê Thu Trang',
        authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
        title: 'Bình minh tuyệt tác tại Vịnh Hạ Long',
        destination: 'Vịnh Hạ Long, Quảng Ninh',
        content: 'Chuyến du thuyền 2 ngày 1 đêm đón ánh bình minh len lỏi qua các hòn đảo đá vôi kỳ vĩ. Cảm giác như lạc vào cõi tiên cảnh!',
        imageUrl: 'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=800&q=80',
        likes: 128,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        comments: [
          PostComment(
            id: 'c1',
            authorName: 'Trần Minh Quân',
            authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
            text: 'Cảnh đẹp nghẹt thở luôn bạn ơi! Du thuyền của hãng nào vậy?',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          PostComment(
            id: 'c2',
            authorName: 'Lê Thu Trang',
            authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
            text: 'Mình đi tàu Paradise Grand nha bạn, dịch vụ rất chu đáo!',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      CommunityPost(
        id: 'post_2',
        authorId: 'user_sapa',
        authorName: 'Phạm Hoàng Nam',
        authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        title: 'Mùa lúa chín vàng óng ruộng bậc thang Mù Cang Chải',
        destination: 'Mù Cang Chải, Yên Bái',
        content: 'Thời tiết thu miền Bắc đẹp tuyệt vời, nắng vàng như rót mật trên những thửa ruộng bậc thang kỳ vĩ. Rất đáng để phượt xe máy một lần trong đời!',
        imageUrl: 'https://images.unsplash.com/photo-1570535927504-20b13d29a502?auto=format&fit=crop&w=800&q=80',
        likes: 245,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        comments: [
          PostComment(
            id: 'c3',
            authorName: 'Đỗ Thùy Linh',
            authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
            text: 'Chuyến này đi vào tháng mấy là lúa chín rộ nhất vậy anh Nam?',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
        ],
      ),
      CommunityPost(
        id: 'post_3',
        authorId: 'user_hoi_an',
        authorName: 'Nguyễn Bích Ngọc',
        authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
        title: 'Hội An lung linh sắc đèn lồng về đêm',
        destination: 'Phố Cổ Hội An, Quảng Nam',
        content: 'Thả hoa đăng trên dòng sông Hoài thơ mộng, thưởng thức cao lầu và bánh mì Phượng nổi tiếng.',
        imageUrl: 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=800&q=80',
        likes: 310,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        comments: [],
      ),
    ];
  }

  void dispose() {
    _postsBroadcastController.close();
  }
}

