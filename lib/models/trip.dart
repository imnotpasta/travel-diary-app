class Trip {
  final int? id;
  final String userId;
  final String title;
  final String destination;
  final DateTime startDate;
  final double budget;
  final String itinerary;
  final String? coverImage;
  final DateTime createdAt;

  Trip({
    this.id,
    this.userId = 'traveller_demo_99',
    required this.title,
    required this.destination,
    required this.startDate,
    required this.budget,
    required this.itinerary,
    this.coverImage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'destination': destination,
      'start_date': startDate.toIso8601String(),
      'budget': budget,
      'itinerary': itinerary,
      'cover_image': coverImage,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as int?,
      userId: map['user_id'] as String? ?? 'traveller_demo_99',
      title: map['title'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      startDate: DateTime.tryParse(map['start_date'] as String? ?? '') ?? DateTime.now(),
      budget: (map['budget'] as num?)?.toDouble() ?? 0.0,
      itinerary: map['itinerary'] as String? ?? '',
      coverImage: map['cover_image'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Trip copyWith({
    int? id,
    String? userId,
    String? title,
    String? destination,
    DateTime? startDate,
    double? budget,
    String? itinerary,
    String? coverImage,
    DateTime? createdAt,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      budget: budget ?? this.budget,
      itinerary: itinerary ?? this.itinerary,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
