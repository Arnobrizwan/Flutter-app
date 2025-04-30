import '../model/trip_api_model.dart';

class TripService {
  Future<List<TripApiModel>> fetchTrips() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      TripApiModel(
        title: "Romantic Parisian Getaway",
        description: "Stroll along the Seine, dine in candlelit bistros, and explore iconic landmarks.",
        dateRange: "14th May - 21st May, 2024",
        tags: ["City", "Couples"],
        activities: [
          "16th May, Evening - Seine River Cruise",
          "17th May, Evening - Marais Fine Dining",
          "20th May, Morning - Louvre Museum Tour",
        ],
      ),
    ];
  }
}