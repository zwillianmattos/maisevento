import 'package:maisevento/models/event.dart';
import 'package:maisevento/services/database_service.dart';
import 'package:maisevento/exceptions.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:maisevento/services/auth_service.dart';

class EventService {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();

  Future<void> createEvent(Event event, String token) async {
    final userId = _authService.verifyToken(token);
    if (userId == null) {
      throw UnauthorizedException(message: 'Invalid or expired token');
    }

    try {
      await _databaseService.insertEvent(event);
    } catch (e) {
      throw EventCreationException(
          message: 'Failed to create event: ${e.toString()}');
    }
  }

  Future<List<Event>> getAllEvents() async {
    try {
      return await _databaseService.getAllEvents();
    } catch (e) {
      throw EventFetchException(
          message: 'Failed to fetch events: ${e.toString()}');
    }
  }

  Future<Event?> getEventById(String id) async {
    try {
      return await _databaseService.getEventById(ObjectId.parse(id));
    } catch (e) {
      throw EventFetchException(
          message: 'Failed to fetch event: ${e.toString()}');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _databaseService.updateEvent(event);
    } catch (e) {
      throw EventUpdateException(
          message: 'Failed to update event: ${e.toString()}');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _databaseService.deleteEvent(ObjectId.parse(id));
    } catch (e) {
      throw EventDeletionException(
          message: 'Failed to delete event: ${e.toString()}');
    }
  }
}
