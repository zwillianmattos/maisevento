import 'package:maisevento/data/models/event_model.dart';

import '../../domain/entities/event.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/get_all_events_usecase.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import '../../core/errors/failures.dart';

class EventController {
  final CreateEventUseCase createEventUseCase;
  final GetAllEventsUseCase getAllEventsUseCase;

  EventController(this.createEventUseCase, this.getAllEventsUseCase);

  Future<Response> createEvent(Request request) async {
    try {
      final payload = await request.readAsString();
      final Map<String, dynamic> eventData = json.decode(payload);

      final event = Event(
        id: '',
        title: eventData['title'],
        description: eventData['description'],
        date: DateTime.parse(eventData['date']),
        location: eventData['location'],
        activities: eventData['activities'],
        capacity: eventData['capacity'],
      );

      final createdEvent = await createEventUseCase.execute(event);

      return Response.ok(
        json.encode({
          'id': createdEvent.id,
          'title': createdEvent.title,
          'description': createdEvent.description,
          'date': createdEvent.date.toIso8601String(),
          'location': createdEvent.location,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      if (e is ValidationFailure) {
        return Response.badRequest(
          body: json.encode({'error': e.message}),
          headers: {'Content-Type': 'application/json'},
        );
      } else if (e is ServerFailure) {
        return Response.internalServerError(
          body: json.encode({'error': e.message}),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response.internalServerError(
          body: json.encode({'error': 'An unexpected error occurred'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    }
  }

  Future<Response> getAllEvents(Request request) async {
    try {
      final events = await getAllEventsUseCase.execute();

      final eventsJson = events
          .map((event) => {
                'id': event.id,
                'title': event.title,
                'description': event.description,
                'date': event.date.toIso8601String(),
                'location': event.location,
                'activities': event.activities,
                'capacity': event.capacity,
              })
          .toList();

      return Response.ok(
        json.encode(eventsJson),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': 'Failed to get events'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
