class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final List<String> activities;
  final int capacity;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.activities,
    required this.capacity,
  });
}
