import 'package:flutter/material.dart';
import '../../../domain/models/trip.dart';
import '../../../data/repositories/trip_repository.dart';

class HomeViewModel extends ChangeNotifier {
  TripRepository? _tripRepository;

  void setRepository(TripRepository repo) {
    _tripRepository = repo;
  }

  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTrips() async {
    if (_tripRepository == null) return;

    _isLoading = true;
    notifyListeners();

    _trips = await _tripRepository!.getTrips();

    _isLoading = false;
    notifyListeners();
  }
}