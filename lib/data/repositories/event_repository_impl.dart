import 'package:maisevento/maisevento.dart';

import '../datasources/event_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDataSource dataSource;

  EventRepositoryImpl(this.dataSource);

  @override
  Future<Event?> getEventById(String id) async {
    final eventModel = await dataSource.getEventById(id);
    return eventModel != null ? _convertToEvent(eventModel) : null;
  }

  @override
  Future<List<Event>> getAllEvents() async {
    final eventModels = await dataSource.getAllEvents();
    return eventModels.map(_convertToEvent).toList();
  }

  @override
  Future<Event> createEvent(Event event) async {
    final eventModel = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      activities: event.activities,
      capacity: event.capacity,
    );
    final createdEvent = await dataSource.createEvent(eventModel);
    return _convertToEvent(createdEvent);
  }

  @override
  Future<Event> updateEvent(Event event) async {
    final eventModel = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      activities: event.activities,
      capacity: event.capacity,
    );
    final updatedEvent = await dataSource.updateEvent(eventModel);
    return _convertToEvent(updatedEvent);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await dataSource.deleteEvent(id);
  }

  Event _convertToEvent(EventModel model) {
    return Event(
      id: model.id.toString(), // Garante que o id seja uma string
      title: model.title,
      description: model.description,
      date: model.date,
      location: model.location,
      activities: model.activities,
      capacity: model.capacity,
    );
  }
}
