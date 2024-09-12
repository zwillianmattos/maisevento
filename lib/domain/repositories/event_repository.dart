import 'package:maisevento/data/models/event_model.dart';

import '../entities/event.dart';

abstract class EventRepository {
  Future<Event> createEvent(Event event);
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(String id);
  Future<Event> updateEvent(Event event);
  Future<void> deleteEvent(String id);
}
