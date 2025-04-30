import '../../domain/models/trip.dart';

class TripApiModel {
  final String title;
  final String description;
  final String dateRange;
  final List<String> tags;
  final List<String> activities;

  TripApiModel({
    required this.title,
    required this.description,
    required this.dateRange,
    required this.tags,
    required this.activities,
  });

  Trip toDomain() {
    return Trip(
      title: title,
      description: description,
      dateRange: dateRange,
      tags: tags,
      activities: activities,
    );
  }
}