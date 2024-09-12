import 'package:maisevento/maisevento.dart';
import '../models/event_model.dart';
import '../../infrastructure/services/database_service.dart';

abstract class EventDataSource {
  Future<EventModel> createEvent(EventModel event);
  Future<List<EventModel>> getAllEvents();
  Future<EventModel?> getEventById(String id);
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String id);
}

class EventDataSourceImpl implements EventDataSource {
  final DatabaseService _databaseService;

  EventDataSourceImpl(this._databaseService);

  @override
  Future<EventModel> createEvent(EventModel event) async {
    final result = await _databaseService.create('events', event.toJson());
    return EventModel.fromJson(result);
  }

  @override
  Future<List<EventModel>> getAllEvents() async {
    final results = await _databaseService.getAll('events');
    return results.map((json) => EventModel.fromJson(json)).toList();
  }

  @override
  Future<EventModel?> getEventById(String id) async {
    final result = await _databaseService.get('events', id);
    return result.isNotEmpty ? EventModel.fromJson(result) : null;
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    final result =
        await _databaseService.update('events', event.id, event.toJson());
    return EventModel.fromJson(result);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _databaseService.delete('events', id);
  }
}
