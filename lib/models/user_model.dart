class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String bio;
  final String homeCity;
  final DateTime joinedAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.bio = 'Đam mê xê dịch & khám phá những vùng đất mới!',
    this.homeCity = 'Hà Nội',
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'homeCity': homeCity,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Du khách',
      photoUrl: map['photoUrl'] as String?,
      bio: map['bio'] as String? ?? 'Đam mê xê dịch & khám phá những vùng đất mới!',
      homeCity: map['homeCity'] as String? ?? 'Hà Nội',
      joinedAt: DateTime.tryParse(map['joinedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? bio,
    String? homeCity,
    DateTime? joinedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      homeCity: homeCity ?? this.homeCity,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

