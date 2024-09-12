import 'package:maisevento/maisevento.dart';

class EventModel extends Event {
  EventModel({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required List<String> activities,
    required int capacity,
  }) : super(
          id: id,
          title: title,
          description: description,
          date: date,
          location: location,
          activities: activities,
          capacity: capacity,
        );

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id']?.toString() ?? '', // Garante que o id seja uma string
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      location: json['location'] ?? '',
      activities: List<String>.from(json['activities'] ?? []),
      capacity: json['capacity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'activities': activities,
      'capacity': capacity,
    };
  }
}
