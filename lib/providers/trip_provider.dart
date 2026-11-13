import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/memory.dart';
import '../services/database_helper.dart';

class TripProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Trip> _trips = [];
  List<TripMemory> _allMemories = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Trip> get trips => _trips;
  List<TripMemory> get allMemories => _allMemories;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  TripProvider() {
    loadTrips();
    loadAllMemories();
  }

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_searchQuery.trim().isEmpty) {
        _trips = await _dbHelper.getAllTrips();
      } else {
        _trips = await _dbHelper.searchTrips(_searchQuery);
      }
    } catch (e) {
      debugPrint('Error loading trips: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchTrips(String query) async {
    _searchQuery = query;
    await loadTrips();
  }

  Future<int> addTrip(Trip trip) async {
    final id = await _dbHelper.insertTrip(trip);
    await loadTrips();
    return id;
  }

  Future<void> updateTrip(Trip trip) async {
    await _dbHelper.updateTrip(trip);
    await loadTrips();
  }

  Future<void> deleteTrip(int id) async {
    await _dbHelper.deleteTrip(id);
    await loadTrips();
    await loadAllMemories();
  }

  // --- Quản lý kỷ niệm & album ảnh ---
  Future<void> loadAllMemories() async {
    try {
      _allMemories = await _dbHelper.getAllMemories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading memories: $e');
    }
  }

  Future<List<TripMemory>> getMemoriesForTrip(int tripId) async {
    return await _dbHelper.getMemoriesByTripId(tripId);
  }

  Future<void> addMemory(TripMemory memory) async {
    await _dbHelper.insertMemory(memory);
    await loadAllMemories();
  }

  Future<void> deleteMemory(int id) async {
    await _dbHelper.deleteMemory(id);
    await loadAllMemories();
  }
}

