import 'dart:async';
import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/memory.dart';
import '../services/auth_service.dart';
import '../services/database_helper.dart';

class TripProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AuthService _authService = AuthService();

  StreamSubscription? _authSubscription;
  String? _currentUserId;

  List<Trip> _trips = [];
  List<TripMemory> _allMemories = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Trip> get trips => _trips;
  List<TripMemory> get allMemories => _allMemories;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  TripProvider() {
    _currentUserId = _authService.currentUser?.uid ?? 'traveller_demo_99';
    _authSubscription = _authService.authStateChanges.listen((user) {
      final newUid = user?.uid ?? 'traveller_demo_99';
      if (_currentUserId != newUid) {
        _currentUserId = newUid;
        loadTrips();
        loadAllMemories();
      }
    });

    loadTrips();
    loadAllMemories();
  }

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();
    try {
      final uid = _currentUserId ?? _authService.currentUser?.uid ?? 'traveller_demo_99';
      if (_searchQuery.trim().isEmpty) {
        _trips = await _dbHelper.getAllTrips(userId: uid);
      } else {
        _trips = await _dbHelper.searchTrips(_searchQuery, userId: uid);
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
    final uid = _currentUserId ?? _authService.currentUser?.uid ?? 'traveller_demo_99';
    final tripToInsert = trip.copyWith(userId: uid);
    final id = await _dbHelper.insertTrip(tripToInsert);
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
      final uid = _currentUserId ?? _authService.currentUser?.uid ?? 'traveller_demo_99';
      _allMemories = await _dbHelper.getAllMemories(userId: uid);
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
