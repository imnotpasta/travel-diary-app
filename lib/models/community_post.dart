class PostComment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String text;
  final DateTime createdAt;

  PostComment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostComment.fromMap(Map<String, dynamic> map) {
    return PostComment(
      id: map['id'] as String? ?? '',
      authorName: map['authorName'] as String? ?? 'Du khách ẩn danh',
      authorAvatar: map['authorAvatar'] as String? ?? '',
      text: map['text'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String title;
  final String destination;
  final String content;
  final String imageUrl;
  final int likes;
  final DateTime createdAt;
  final List<PostComment> comments;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.title,
    required this.destination,
    required this.content,
    required this.imageUrl,
    this.likes = 0,
    required this.createdAt,
    this.comments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'title': title,
      'destination': destination,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory CommunityPost.fromMap(Map<String, dynamic> map) {
    final commentList = (map['comments'] as List<dynamic>? ?? [])
        .map((e) => PostComment.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    return CommunityPost(
      id: map['id'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? 'Du khách',
      authorAvatar: map['authorAvatar'] as String? ?? '',
      title: map['title'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      content: map['content'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      comments: commentList,
    );
  }

  CommunityPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? title,
    String? destination,
    String? content,
    String? imageUrl,
    int? likes,
    DateTime? createdAt,
    List<PostComment>? comments,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}

