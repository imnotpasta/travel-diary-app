class TripMemory {
  final int? id;
  final int tripId;
  final String imagePath;
  final String caption;
  final String location;
  final DateTime date;
  final double rating;

  TripMemory({
    this.id,
    required this.tripId,
    required this.imagePath,
    required this.caption,
    required this.location,
    required this.date,
    this.rating = 5.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'image_path': imagePath,
      'caption': caption,
      'location': location,
      'date': date.toIso8601String(),
      'rating': rating,
    };
  }

  factory TripMemory.fromMap(Map<String, dynamic> map) {
    return TripMemory(
      id: map['id'] as int?,
      tripId: map['trip_id'] as int? ?? 0,
      imagePath: map['image_path'] as String? ?? '',
      caption: map['caption'] as String? ?? '',
      location: map['location'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }

  TripMemory copyWith({
    int? id,
    int? tripId,
    String? imagePath,
    String? caption,
    String? location,
    DateTime? date,
    double? rating,
  }) {
    return TripMemory(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      imagePath: imagePath ?? this.imagePath,
      caption: caption ?? this.caption,
      location: location ?? this.location,
      date: date ?? this.date,
      rating: rating ?? this.rating,
    );
  }
}

