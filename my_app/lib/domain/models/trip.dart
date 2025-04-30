class Trip {
  final String title;
  final String description;
  final String dateRange;
  final List<String> tags;
  final List<String> activities;

  Trip({
    required this.title,
    required this.description,
    required this.dateRange,
    required this.tags,
    required this.activities,
  });
}