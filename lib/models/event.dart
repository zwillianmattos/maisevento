import 'package:mongo_dart/mongo_dart.dart';

class Event {
  ObjectId? id;
  final String name;
  final String description;
  final DateTime date;
  final String location;
  final int capacity;
  final List<String> activities;

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.capacity,
    required this.activities,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'capacity': capacity,
      'activities': activities,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as ObjectId?,
      name: json['name'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      capacity: json['capacity'] as int,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
