import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/trip.dart';
import '../models/memory.dart';

class DatabaseHelper {
  static const _databaseName = "travel_diary.db";
  static const _databaseVersion = 2;

  // Table trips
  static const tableTrips = 'trips';
  static const columnTripId = 'id';
  static const columnTripUserId = 'user_id';
  static const columnTripTitle = 'title';
  static const columnTripDestination = 'destination';
  static const columnTripStartDate = 'start_date';
  static const columnTripBudget = 'budget';
  static const columnTripItinerary = 'itinerary';
  static const columnTripCoverImage = 'cover_image';
  static const columnTripCreatedAt = 'created_at';

  // Table memories
  static const tableMemories = 'trip_memories';
  static const columnMemoryId = 'id';
  static const columnMemoryTripId = 'trip_id';
  static const columnMemoryImagePath = 'image_path';
  static const columnMemoryCaption = 'caption';
  static const columnMemoryLocation = 'location';
  static const columnMemoryDate = 'date';
  static const columnMemoryRating = 'rating';

  // Singleton instance
  DatabaseHelper._privateConstructor() {
    if (kIsWeb) {
      _initWebSampleData();
    }
  }
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Web Fallback Storage
  final List<Trip> _webTrips = [];
  final List<TripMemory> _webMemories = [];
  int _webTripCounter = 1;
  int _webMemoryCounter = 1;

  void _initWebSampleData() {
    _webTrips.addAll([
      Trip(
        id: _webTripCounter++,
        userId: 'traveller_demo_99',
        title: 'Khám phá Đà Lạt Mộng Mơ',
        destination: 'Đà Lạt, Lâm Đồng',
        startDate: DateTime.now().add(const Duration(days: 3)),
        budget: 4500000.0,
        itinerary:
            '- Ngày 1: Hồ Xuân Hương, Quảng trường Lâm Viên, Chợ Đêm.\n- Ngày 2: Đồi Chè Cầu Đất, Cà phê Mê Linh, Thác Datanla.\n- Ngày 3: Thung lũng Tình Yêu, Mua đặc sản mứt dâu & hoa quả.',
        coverImage:
            'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now(),
      ),
      Trip(
        id: _webTripCounter++,
        userId: 'traveller_demo_99',
        title: 'Hành trình Biển xanh Phú Quốc',
        destination: 'Phú Quốc, Kiên Giang',
        startDate: DateTime.now().add(const Duration(days: 14)),
        budget: 8500000.0,
        itinerary:
            '- Ngày 1: Check-in Sunset Sanato, Dạo chợ đêm Bạch Đằng.\n- Ngày 2: Tour 4 đảo lặn ngắm san hô (Hòn Móng Tay, Hòn Gầm Ghì).\n- Ngày 3: Tham quan Grand World và VinWonders.',
        coverImage:
            'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now(),
      ),
    ]);

    _webMemories.addAll([
      TripMemory(
        id: _webMemoryCounter++,
        tripId: 1,
        imagePath:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
        caption: 'Bình minh sáng sớm trên đỉnh đồi sương mờ',
        location: 'Đồi Đa Phú, Đà Lạt',
        date: DateTime.now(),
        rating: 5.0,
      ),
      TripMemory(
        id: _webMemoryCounter++,
        tripId: 1,
        imagePath:
            'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=800&q=80',
        caption: 'Tách cà phê ấm ngắm trọn rừng thông',
        location: 'Quán Gió Đà Lạt',
        date: DateTime.now(),
        rating: 4.8,
      ),
      TripMemory(
        id: _webMemoryCounter++,
        tripId: 2,
        imagePath:
            'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=800&q=80',
        caption: 'Hoàng hôn rực rỡ biển Bãi Sao',
        location: 'Bãi Sao, Phú Quốc',
        date: DateTime.now(),
        rating: 5.0,
      ),
    ]);
  }

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError(
          'SQLite binary native is not run on Web. Using web fallback repository.');
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTrips (
        $columnTripId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTripUserId TEXT NOT NULL,
        $columnTripTitle TEXT NOT NULL,
        $columnTripDestination TEXT NOT NULL,
        $columnTripStartDate TEXT NOT NULL,
        $columnTripBudget REAL NOT NULL,
        $columnTripItinerary TEXT NOT NULL,
        $columnTripCoverImage TEXT,
        $columnTripCreatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMemories (
        $columnMemoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMemoryTripId INTEGER NOT NULL,
        $columnMemoryImagePath TEXT NOT NULL,
        $columnMemoryCaption TEXT,
        $columnMemoryLocation TEXT,
        $columnMemoryDate TEXT NOT NULL,
        $columnMemoryRating REAL DEFAULT 5.0,
        FOREIGN KEY ($columnMemoryTripId) REFERENCES $tableTrips ($columnTripId) ON DELETE CASCADE
      )
    ''');

    await _insertInitialSampleData(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $tableTrips ADD COLUMN $columnTripUserId TEXT DEFAULT "traveller_demo_99"',
      );
    }
  }

  Future<void> _insertInitialSampleData(Database db) async {
    final sampleTripId1 = await db.insert(tableTrips, {
      columnTripUserId: 'traveller_demo_99',
      columnTripTitle: 'Khám phá Đà Lạt Mộng Mơ',
      columnTripDestination: 'Đà Lạt, Lâm Đồng',
      columnTripStartDate:
          DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      columnTripBudget: 4500000.0,
      columnTripItinerary:
          '- Ngày 1: Hồ Xuân Hương, Quảng trường Lâm Viên, Chợ Đêm.\n- Ngày 2: Đồi Chè Cầu Đất, Cà phê Mê Linh, Thác Datanla.\n- Ngày 3: Thung lũng Tình Yêu, Mua đặc sản mứt dâu & hoa quả.',
      columnTripCoverImage:
          'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=800&q=80',
      columnTripCreatedAt: DateTime.now().toIso8601String(),
    });

    final sampleTripId2 = await db.insert(tableTrips, {
      columnTripUserId: 'traveller_demo_99',
      columnTripTitle: 'Hành trình Biển xanh Phú Quốc',
      columnTripDestination: 'Phú Quốc, Kiên Giang',
      columnTripStartDate:
          DateTime.now().add(const Duration(days: 14)).toIso8601String(),
      columnTripBudget: 8500000.0,
      columnTripItinerary:
          '- Ngày 1: Check-in Sunset Sanato, Dạo chợ đêm Bạch Đằng.\n- Ngày 2: Tour 4 đảo lặn ngắm san hô (Hòn Móng Tay, Hòn Gầm Ghì).\n- Ngày 3: Tham quan Grand World và VinWonders.',
      columnTripCoverImage:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
      columnTripCreatedAt: DateTime.now().toIso8601String(),
    });

    await db.insert(tableMemories, {
      columnMemoryTripId: sampleTripId1,
      columnMemoryImagePath:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
      columnMemoryCaption: 'Bình minh sáng sớm trên đỉnh đồi sương mờ',
      columnMemoryLocation: 'Đồi Đa Phú, Đà Lạt',
      columnMemoryDate: DateTime.now().toIso8601String(),
      columnMemoryRating: 5.0,
    });

    await db.insert(tableMemories, {
      columnMemoryTripId: sampleTripId1,
      columnMemoryImagePath:
          'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=800&q=80',
      columnMemoryCaption: 'Tách cà phê ấm ngắm trọn rừng thông',
      columnMemoryLocation: 'Quán Gió Đà Lạt',
      columnMemoryDate: DateTime.now().toIso8601String(),
      columnMemoryRating: 4.8,
    });

    await db.insert(tableMemories, {
      columnMemoryTripId: sampleTripId2,
      columnMemoryImagePath:
          'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=800&q=80',
      columnMemoryCaption: 'Hoàng hôn rực rỡ biển Bãi Sao',
      columnMemoryLocation: 'Bãi Sao, Phú Quốc',
      columnMemoryDate: DateTime.now().toIso8601String(),
      columnMemoryRating: 5.0,
    });
  }

  // ==================== C R U D   T R I P S ====================

  Future<int> insertTrip(Trip trip) async {
    if (kIsWeb) {
      final newId = _webTripCounter++;
      _webTrips.insert(0, trip.copyWith(id: newId));
      return newId;
    }
    final db = await database;
    return await db.insert(
      tableTrips,
      trip.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Trip>> getAllTrips({String? userId}) async {
    if (kIsWeb) {
      if (userId != null) {
        return _webTrips.where((t) => t.userId == userId).toList();
      }
      return List.unmodifiable(_webTrips);
    }
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTrips,
      where: userId != null ? '$columnTripUserId = ?' : null,
      whereArgs: userId != null ? [userId] : null,
      orderBy: '$columnTripCreatedAt DESC',
    );
    return maps.map((map) => Trip.fromMap(map)).toList();
  }

  Future<Trip?> getTripById(int id) async {
    if (kIsWeb) {
      return _webTrips.where((t) => t.id == id).firstOrNull;
    }
    final db = await database;
    final maps = await db.query(
      tableTrips,
      where: '$columnTripId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Trip.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTrip(Trip trip) async {
    if (kIsWeb) {
      final index = _webTrips.indexWhere((t) => t.id == trip.id);
      if (index != -1) {
        _webTrips[index] = trip;
        return 1;
      }
      return 0;
    }
    final db = await database;
    return await db.update(
      tableTrips,
      trip.toMap(),
      where: '$columnTripId = ?',
      whereArgs: [trip.id],
    );
  }

  Future<int> deleteTrip(int id) async {
    if (kIsWeb) {
      _webTrips.removeWhere((t) => t.id == id);
      _webMemories.removeWhere((m) => m.tripId == id);
      return 1;
    }
    final db = await database;
    return await db.delete(
      tableTrips,
      where: '$columnTripId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Trip>> searchTrips(String query, {String? userId}) async {
    if (kIsWeb) {
      final lower = query.toLowerCase();
      return _webTrips.where((t) {
        final matchesUser = userId == null || t.userId == userId;
        final matchesQuery = t.title.toLowerCase().contains(lower) ||
            t.destination.toLowerCase().contains(lower);
        return matchesUser && matchesQuery;
      }).toList();
    }
    final db = await database;
    String whereClause =
        '($columnTripTitle LIKE ? OR $columnTripDestination LIKE ?)';
    List<dynamic> whereArgs = ['%$query%', '%$query%'];

    if (userId != null) {
      whereClause += ' AND $columnTripUserId = ?';
      whereArgs.add(userId);
    }

    final maps = await db.query(
      tableTrips,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '$columnTripCreatedAt DESC',
    );
    return maps.map((map) => Trip.fromMap(map)).toList();
  }

  // ==================== C R U D   M E M O R I E S ====================

  Future<int> insertMemory(TripMemory memory) async {
    if (kIsWeb) {
      final newId = _webMemoryCounter++;
      _webMemories.insert(0, memory.copyWith(id: newId));
      return newId;
    }
    final db = await database;
    return await db.insert(
      tableMemories,
      memory.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TripMemory>> getMemoriesByTripId(int tripId) async {
    if (kIsWeb) {
      return _webMemories.where((m) => m.tripId == tripId).toList();
    }
    final db = await database;
    final maps = await db.query(
      tableMemories,
      where: '$columnMemoryTripId = ?',
      whereArgs: [tripId],
      orderBy: '$columnMemoryDate DESC',
    );
    return maps.map((map) => TripMemory.fromMap(map)).toList();
  }

  Future<List<TripMemory>> getAllMemories({String? userId}) async {
    if (kIsWeb) {
      if (userId != null) {
        final userTripIds =
            _webTrips.where((t) => t.userId == userId).map((t) => t.id).toSet();
        return _webMemories
            .where((m) => userTripIds.contains(m.tripId))
            .toList();
      }
      return List.unmodifiable(_webMemories);
    }
    final db = await database;
    if (userId != null) {
      final maps = await db.rawQuery('''
        SELECT m.* FROM $tableMemories m
        INNER JOIN $tableTrips t ON m.$columnMemoryTripId = t.$columnTripId
        WHERE t.$columnTripUserId = ?
        ORDER BY m.$columnMemoryDate DESC
      ''', [userId]);
      return maps.map((map) => TripMemory.fromMap(map)).toList();
    }

    final maps = await db.query(
      tableMemories,
      orderBy: '$columnMemoryDate DESC',
    );
    return maps.map((map) => TripMemory.fromMap(map)).toList();
  }

  Future<int> updateMemory(TripMemory memory) async {
    if (kIsWeb) {
      final index = _webMemories.indexWhere((m) => m.id == memory.id);
      if (index != -1) {
        _webMemories[index] = memory;
        return 1;
      }
      return 0;
    }
    final db = await database;
    return await db.update(
      tableMemories,
      memory.toMap(),
      where: '$columnMemoryId = ?',
      whereArgs: [memory.id],
    );
  }

  Future<int> deleteMemory(int id) async {
    if (kIsWeb) {
      _webMemories.removeWhere((m) => m.id == id);
      return 1;
    }
    final db = await database;
    return await db.delete(
      tableMemories,
      where: '$columnMemoryId = ?',
      whereArgs: [id],
    );
  }
}
