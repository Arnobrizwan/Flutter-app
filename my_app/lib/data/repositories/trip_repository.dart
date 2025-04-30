import '../services/trip_service.dart';
import '../model/trip_api_model.dart';
import '../../domain/models/trip.dart';

class TripRepository {
  final TripService _tripService;

  TripRepository(this._tripService);

  Future<List<Trip>> getTrips() async {
    final apiTrips = await _tripService.fetchTrips();
    return apiTrips.map((apiTrip) => apiTrip.toDomain()).toList();
  }
}